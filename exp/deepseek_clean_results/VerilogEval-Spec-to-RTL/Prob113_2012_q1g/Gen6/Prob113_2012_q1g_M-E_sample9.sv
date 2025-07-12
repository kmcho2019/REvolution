module TopModule(
    input [3:0] x,
    output f
);
    // Pattern matching implementation
    wire match1 = (x == 4'b0000);  // row00,col00
    wire match2 = (x == 4'b0010);  // row00,col10
    wire match3 = (x == 4'b1100);  // row11,col00
    wire match4 = (x == 4'b1101);  // row11,col01
    wire match5 = (x == 4'b1111);  // row11,col11
    wire match6 = (x == 4'b1000);  // row10,col00
    wire match7 = (x == 4'b1001);  // row10,col01
    wire match8 = (x == 4'b1010);  // row10,col10

    // Combine all matches
    assign f = match1 | match2 | match3 | 
               match4 | match5 | match6 | 
               match7 | match8;
endmodule