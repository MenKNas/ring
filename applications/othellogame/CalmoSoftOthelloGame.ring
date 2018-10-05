# Project : Othello Game
# Date    : 2018/09/26
# Author : Gal Zsolt (~ CalmoSoft ~), Bert Mariani
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
load "guilib.ring"


Size  = 8
Score = 0

sumMoveBlack = 0
sumMoveWhite = 0

C_Spacing = 3 ### was 5

C_EmptyButtonStyle  = 'border-radius:6px;background-color:gray'
C_ButtonBlackStyle  = 'border-radius:6px;color:black; background-color: black'
C_ButtonWhiteStyle  = 'border-radius:6px;color:black; background-color: white'
C_ButtonOrangeStyle = 'border-radius:6px;color:black; background-color: orange'

C_ButtonBlueStyle   = 'border-radius:6px;color:black; background-color: Cyan'
C_ButtonYellowStyle = 'border-radius:6px;color:black; background-color: Yellow'

Button          = newlist(Size+1,Size)
LayoutButtonRow = list(Size+4)

curColor  	= "B"	### "B" or "W"

TransScript = list(1)
MoveNumber  = 1
dArray      = list(8)			### Flat destination array for diagnal analysis
bArray	    = newList(8,8)		### Internal button array
oldArray    = newList(8,8)		### Save bArray as oldArray, See who flip for Animation

###=====================================================

app = new qApp 
{
	win = new qWidget() {
		setWindowTitle('Othello Game')
		setStyleSheet('background-color:green')

		  move(500,100)
		reSize(600,600)
		winheight = win.height()
		fontSize = 8 + (winheight / 100)

		PlayScoreBlack = new QLabel(win) 
						{
							setFont(new qFont("Verdana",fontSize,100,0))
							setstylesheet(C_ButtonBlueStyle)
							setalignment(Qt_AlignHCenter | Qt_AlignVCenter)
							settext("Black Score: 2")
						}

		PlayScoreWhite = new QLabel(win) 
						{
							setFont(new qFont("Verdana",fontSize,100,0))
							setstylesheet(C_ButtonYellowStyle)
							setalignment(Qt_AlignHCenter | Qt_AlignVCenter)
							settext("White Score: 2")
						}

		NextMove = new QLabel(win) 
						{
							setFont(new qFont("Verdana",fontSize,100,0))
							setstylesheet(C_ButtonOrangestyle)
							setalignment(Qt_AlignHCenter | Qt_AlignVCenter)
							settext("Next Move: Black ")
						} 

		NewGame  = new QPushButton(win) 
						{
							setFont(new qFont("Verdana",fontSize,100,0))
							setstylesheet("background-color:violet")
							settext("New Game")
							setclickevent("pStart()")				### CLICK NEW GAME >>> pStart
						}

        ##------------------------------------------------------------------------------
		### QVBoxLayout lays out Button Widgets in a vertical column, from top to bottom.
		
		LayoutButtonMain = new QVBoxLayout()			### VERTICAL
		LayoutButtonMain.setSpacing(C_Spacing)
		LayoutButtonMain.setContentsmargins(0,0,0,0)

		
			###-------------------------------------------
			### Title Top Row - LETTERS  @ A B C D E F G H
			
			TitleLet = list(9)		### Array of qLabel Object		
			Number = 64  			### 64=@ A B .. H

			for Col = 1 to 9
				Letter = hex2str( hex(Number))
				TitleLet[Col] = new qLabel(win) { setFont(new qFont("Verdana",fontSize,100,0)) setAlignment(Qt_AlignHCenter | Qt_AlignVCenter) setStyleSheet("background-color:darkgray") 	setText(Letter) } 
				Number++				
			next
				
			###-----------------------------------
			### Horizontal Rows - 1 2 3 4 5 6 7 8
		
			LayoutTitleRow = new QHBoxLayout() { setSpacing(C_Spacing) setContentsMargins(0,0,0,0) }

				for Col = 1 to 9				
					LayoutTitleRow.AddWidget(TitleLet[Col])			
				next
							
			LayoutButtonMain.AddLayout(LayoutTitleRow)	### Layout - Add  TITLE-ROW on TOP
			
			###----------------------------------------------
			### Horizontal Button Rows

			TitleNum = list(9)	### Array of qLabel Object

			for Col = 1 to 8
				Letter = ""+ Col
				TitleNum[Col] = new qLabel(win) { setFont(new qFont("Verdana",fontSize,100,0)) setAlignment(Qt_AlignHCenter | Qt_AlignVCenter) setStyleSheet("background-color:darkgray") 	setText(Letter) } 
				Number++			
				
			next
	  
			###-----------------------------------------------------------------------
			### QHBoxLayout lays out widgets in a horizontal row, from left to right
				
			for Row = 1 to Size
				LayoutButtonRow[Row] = new QHBoxLayout()	### Horizontal
				{
					setSpacing(C_Spacing)
					setContentsmargins(0,0,0,0)
				} 

			   LayoutButtonRow[Row].AddWidget(TitleNum[Row])
			   
			   for Col = 1 to Size
					Button[Row][Col] = new QPushButton(win)	### Create PUSH BUTTONS
					{
						setStyleSheet(C_EmptyButtonStyle)			
						setClickEvent("pPlay(" + string(Row) + "," + string(Col) + ")")   ### CLICK PLAY MOVE >>> pPlay
						setSizePolicy(1,1)
					}
					
					LayoutButtonRow[Row].AddWidget(Button[Row][Col])	### Widget - Add HORZ BOTTON
			   next
			   
			   LayoutButtonMain.AddLayout(LayoutButtonRow[Row])			### Layout - Add ROW of ButtonS
			next

			###------------------------------------------------
			### Horizontal Row Bottom
				LayoutDataRow = new QHBoxLayout() { setSpacing(C_Spacing) setContentsMargins(0,0,0,0) }
				  
					LayoutDataRow.AddWidget(PlayScoreBlack) 
					LayoutDataRow.AddWidget(PlayScoreWhite) 
					LayoutDataRow.AddWidget(NextMove) 
  
				LayoutButtonMain.AddLayout(LayoutDataRow)
				LayoutButtonMain.AddWidget(NewGame)

            setLayout(LayoutButtonMain)
			
			###---------------------------------------------
			
            pStart()
            show()
   }
   exec()
 }

###======================================== 
###========================================

func pStart()

SEE nl+ "===== START START ====="+nl+nl
	bArray	= newList(8,8)

	for Row = 1 to Size
		for Col = 1 to Size
			bArray[Row][Col] = "E"		### E-Empty cell
			Button[Row][Col].setenabled(true)
			Button[Row][Col] { setstylesheet(C_EmptyButtonStyle) }
		next
	next
	
	curColor  = "B"	### 1
	Score     =  0 

	MoveNumber  = 1
	TransScript = list(1)

 
	      NextMove.settext("Next Move: Black ")
	PlayScoreBlack.settext("Black Score: 2")
	PlayScoreWhite.settext("White Score: 2")

	Button[4][4].setenabled(false)
	Button[4][5].setenabled(false)
	Button[5][4].setenabled(false)
	Button[5][5].setenabled(false)

	Button[4][4] { setstylesheet(C_ButtonBlackStyle) }
	Button[5][5] { setstylesheet(C_ButtonBlackStyle) }	 
	Button[4][5] { setstylesheet(C_ButtonWhiteStyle) }	   
	Button[5][4] { setstylesheet(C_ButtonWhiteStyle) }

	bArray[4][4] = "B"	
	bArray[5][5] = "B"	
	bArray[4][5] = "W"	
	bArray[5][4] = "W"	
	
return

###--------------------------------
	   
func sumMove()
       sumMoveBlack = 0
       sumMoveWhite = 0

       for Row = 1 to Size
            for  Col = 1 to Size
                 if bArray[Row][Col] = "B"
                    sumMoveBlack++
                 ok
                 if bArray[Row][Col] = "W"
                    sumMoveWhite++
                 ok 
            next
       next

       PlayScoreBlack.settext("Black Score: " + sumMoveBlack)
       PlayScoreWhite.settext("White Score: " + sumMoveWhite)
return

###-----------------------------------
### Play a Move - qPushButton Clicked
	
Func pPlay(Row,Col)

    SEE nl+"------------------------"+nl+nl
	SEE "CLICK Row-Col: "+ Row +"-"+ Col +nl
	
			###---------------------------
			### TransScript Record Moves
			
			Letter = char(64 + Col)
			if curColor = "B"  ###
			
				MovePlayed = ""+ MoveNumber +"-"+ "B" +"-"+ Row +"-"+ Letter
				NextMove.setstylesheet(C_ButtonWhitestyle)
				NextMove.settext("Next Move: White ")    
			else
				MovePlayed = ""+ MoveNumber +"-"+ "W" +"-"+ Row +"-"+ Letter 
				NextMove.setstylesheet(C_ButtonOrangestyle)
				NextMove.settext("Next Move: Black ") 
			ok      

			TranScript = Add(TransScript, MovePlayed)
			MoveNumber++
			SEE "TransScript: "+nl  SEE TransScript  SEE nl
			
			###-------------------------

	###-------------------------------------------------
	### Make a Copy of Current Board for Flip Animation	
	
	for h = 1 to Size
		for v = 1 to Size
			oldArray[h][v] = bArray[h][v]
		next
	next	
        
	###---------------------------------
	
	if curColor = "B"  									### Current BLACK   
		bArray[Row][Col] = "B"
		Button[Row][Col] { setstylesheet(C_ButtonBlackStyle) }
		Button[Row][Col].setenabled(false)	
		CheckDiagonals(Row,Col,curColor)				### >>>> CHECK Diagonals

		curColor = "W"  								### Next Move is White
		
	elseif  curColor = "W"  							### Current WHITE  
		bArray[Row][Col] = "W"
		Button[Row][Col] { setstylesheet(C_ButtonWhiteStyle) }
		Button[Row][Col].setenabled(false)
		CheckDiagonals(Row,Col,curColor)				### >>>> CHECK Diagonals
		
		curColor = "B"  								### Next Move is Black
		
	ok

	
	###-------------------------------------
	### Color the Buttons and Disable Click
	
	SEE "Color bArray_____"+nl
	for Row = 1 to Size
	See nl + row +" "
		for  Col = 1 to Size
			 
			if bArray[Row][Col] = "W"
				SEE "W "

				if oldArray[Row][Col] != bArray[Row][Col]	### Flip ANIMATION
					#SEE "FlipAnimation: "+ Row +"-"+ Col +" "+ bArray[Row][Col] +nl
					app.processevents()
					sleep(0.2)				
				ok
				
				Button[Row][Col] { setstylesheet(C_ButtonWhiteStyle) }
				Button[Row][Col].setenabled(false)				
			ok

			if bArray[Row][Col] = "B"
				SEE "B "

				if oldArray[Row][Col] != bArray[Row][Col]	### Flip ANIMATION
					#SEE "FlipAnimation: "+ Row +"-"+ Col +" "+ bArray[Row][Col] +nl
					app.processevents()
					sleep(0.2)				
				ok
				
				Button[Row][Col] { setstylesheet(C_ButtonBlackStyle) }
				Button[Row][Col].setenabled(false)				
			ok
			
			if bArray[Row][Col] = "E"
				SEE ". "
			ok	
			
		next

	next
	See nl
		
	sumMove()
return


###=============================================

Func CheckDiagonals(Row,Col,curColor)

#SEE nl+ "##################################"+nl
#SEE "CellCLICK: Row-Col-Color: "+ Row + "-"+ Col +" "+ curColor  +nl

	###---------------------------
	### Diag-  NORTH-SOUTH Col
	### COPY to ROW to FLAT
	
	dArray = list(9) 
	for Cell = 1 to 9  dArray[Cell] = "E"  	next
	
				#See nl+"Copy-NORTH-SOUTH-To-dArray---->>>: "					
			for Cell = 1 to 8	 
				dArray[Cell] = bArray[Cell][Col]  		### ROW ---> FLAT
				#SEE " "+ dArray[Cell]
			next	
				#See nl
	
	CheckFlips(Row,curColor)
	

			### COPY BACK FLAT to COL 
				#See "Copy-dArray-To-NORTH-SOUTH----<<<: "	 	
			for Cell = 1 to 8	 
				bArray[Cell][Col] = dArray[Cell]  		### ROW <--- FLAT
				#See " "+ dArray[Cell] 
			next	
				#see nl
		
		
	###---------------------------
	### Diag-  EAST-WEST Row
	### COPY to ROW to FLAT
	
	dArray = list(9)  
	for Cell = 1 to 9  dArray[Cell] = "E" 	next

				#See nl+"Copy-EAST-WEST-To-dArray---->>>  : "	 	
			for Cell = 1 to 8	 
				dArray[Cell] = bArray[ROW][Cell]  		###  COL ----> FLAT
				#SEE " "+ dArray[Cell]
			next	
				#see nl
		
	CheckFlips(Col,curColor)

	
			### COPY BACK FLAT to ROW 
				#See "Copy-dArray-To-EAST-WEST------<<<: "		
			for Cell = 1 to 8	 
				bArray[Row][Cell] = dArray[Cell]		###  COL <---- FLAT
				#See " "+ dArray[Cell] 
			next	
				#see nl	
				

	###================================================
	### Diag- DECLINE \ 1-A to 8-H
	### COPY to ROW to FLAT
	
	dArray = list(9)  
	for Cell = 1 to 9  dArray[Cell] = "E" 	next
	
			### Backup from current Row-Col till one of them = 1
			Diff = Row - Col
			
			if Diff = 0  StartRow = 1             StartCol = 1             ok
			if Diff > 0  StartRow = Row - Col +1  StartCol = 1             ok
			if Diff < 0  StartRow = 1             StartCol = Col - Row +1  ok
			
			DRow = StartRow   
			DCol = StartCol
			
			#SEE nl+"DECLINE Diff: "+ Diff +" StartRow: "+ StartRow +" StartCol "+ StartCol +nl
			
			
				#See "Copy-DECLINE-To-dArray ------->>>: "
			for Cell = 1 to 8	 
				dArray[Cell] = bArray[DRow][DCol]  		### ROW\COL ---> FLAT
				DRow++  DCol++
				
				#SEE " "+ dArray[Cell]
				
				if DRow > 8 OR DCol > 8  exit  ok				
			next	
				#See nl

				
	CheckFlips((Row-StartRow+1),curColor)				### Line up dArray and Row for Cell Clicked
	
	
			### COPY BACK FLAT to ROW 
			DRow = StartRow   DCol = StartCol
			
				#See "Copy-dArray-To-DECLINE--------<<<: "	
			for Cell = 1 to 8	 
				bArray[DRow][DCol] = dArray[Cell]  		### ROW\COL <--- FLAT
				#See " "+ dArray[Cell] 
				DRow++  DCol++
				
				if DRow > 8 OR DCol > 8  exit  ok  	
			next	
				#see nl
				
	

	###===============================================
	### Diag- INCLINE / 8-A to 1-H
	### COPY to ROW to FLAT

	
	dArray = list(9) 
	for Cell = 1 to 9  dArray[Cell] = "E" 	next
	
			### Backup from current Row-Col till one of them = 1
			Diff = Row - (9 -Col)
						
			if Diff = 0  StartRow = 8             StartCol = 1             ok
			if Diff > 0  StartRow = 8             StartCol = Col - (8-Row) ok
			if Diff < 0  StartRow = Col + (Row-1) StartCol = 1             ok
			
			DRow = StartRow   
			DCol = StartCol
	
			#SEE nl+"INCLINE Diff: "+ Diff +" StartRow: "+ StartRow +" StartCol "+ StartCol +nl
			
				#See "Copy-INCLINE-To-dArray-------->>>: "				
			for Cell = 1 to 8		
				dArray[Cell] = bArray[DRow][DCol]  		### ROW\COL ---> FLAT
				DRow--  DCol++
								
				#SEE " "+ dArray[Cell]
		
				if DRow < 1 OR DCol > 8  exit  ok	
			next	
				#See nl
	
	
	CheckFlips((Col-StartCol+1),curColor)				### Line up dArray and Col for Cell Clicked
	
	
			### COPY BACK FLAT to ROW 
			DRow = StartRow   DCol = StartCol
			
				#See "Copy-dArray-To-INCLINE--------<<<: "			
			for Cell = 1 to 8	 
				bArray[DRow][DCol] = dArray[Cell]  		### ROW\COL <--- FLAT
				#See " "+ dArray[Cell] 
				DRow--  DCol++
				
				if DRow < 1 OR DCol > 8  exit  ok	
			next	
				#see nl
				
	###--------------------------------------------			
		

	
return

###======================================================
### dArray  Pattern to Check 
###               v              Click 4  
###         1 2 3 4 5 6 7 8 .
###         e e B B W W B e .	
###               s     f        4--7  Right match
###
###         B W W B W . B e    
###         s     f              1--4  Left match
###         B W e B W . W B
###         s   - s   -   e      1--cancel-3  4--cancel-7   8  NO match
###
###           V
###         e B W B e B W        2-4  
###           s   f - s - 
###-----------------------------------------------------

Func CheckFlips(cellClick,curColor)

#SEE "CheckFlips: CellClick "+ cellClick +" "+ curColor +nl

    aFlip       = list(9)			### Which Cells to Flip, OverFlop when Cell +1 = 9
	aFlip[9]    =  "."              ### Use Dot, NOT B,W,E on Edge +1
	
    FlipCell    =  0
	otherColor  = "E"
	if curColor = "B" otherColor = "W" ok  
	if curColor = "W" otherColor = "B" ok

	FlagStart  = 0														### dArray = [9]
	
	for cell = 1 to 8													### 8 => OverFlow on array[8+1]	
	
		### START ---
		if dArray[cell] = curColor 	AND dArray[cell+1] = otherColor  	###  ..BW.. 
			cellStart = cell											###  ..^...  FlagStart = 1
			
			FlagStart = 1                                             		
			#SEE "Start__: "+ FlagStart +" "+ cellStart +nl	
	
		### END ---
		elseif  dArray[cell] = otherColor AND dArray[cell+1] = curColor  ###  ..WB..
			cellEnd = cell+1  											###  ...^..
			
			#SEE "End____: "+ FlagStart +" "+ cellEnd +nl
			
			if FlagStart = 1 AND ( (cellStart = cellClick) OR (cellEnd = cellClick) )
				
				FlipStart = cellStart +1  								###  ..BWB..  
				FlipEnd   = cellEnd   -1								###  ..^v^.. 				
				#SEE "FLIPPER: "+ FlipStart +"-"+ FlipEnd + " >>> "
				
				for n = (FlipStart) to (FlipEnd)     
					aFlip[n] = 1 
					#SEE " "+ n 
				next	
					#SEE nl
			
			FlagStart = 0
									
			ok	
			
		### CANCEL ---	
		elseif	dArray[cell] = "E" AND FlagStart = 1           			###  EB, EW, EE => FlagStart = 0
		    FlagStart = 0
		    #SEE "Start_v: "+ FlagStart +" "+ cell +nl
		ok		
		
	next

	#SEE "FLIP___: "
	for n = 1 to 9
		#SEE  aFlip[n] 
			if aFlip[n] = 1
				dArray[n] = curColor	### FLIP color
			ok
	next
	#SEE nl

	#SEE "dArray-Changed-Now_______________: " 	
	#for n = 1 to 8  SEE " "+ dArray[n]  next #SEE nl
	

#See "EndCheck:"+nl	

return

###============================================
###============================================


#
###--------------------------------
	
Func msgBox(cText) 
	mb = new qMessageBox(win) {
	        setWindowTitle('Othello Game')
	        setText(cText)
                setstandardButtons(QMessageBox_OK) 
                result = exec()
        }
        return

###--------------------------------
	
