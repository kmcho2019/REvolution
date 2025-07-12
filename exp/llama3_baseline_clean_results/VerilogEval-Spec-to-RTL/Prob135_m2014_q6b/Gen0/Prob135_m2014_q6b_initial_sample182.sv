module TopModule(
    input  [2:0] y,  // current state
    input        w,  // input
    output       Y1  // output (next state y[1])
);

    assign Y1 = (y == 3'b101)? (w? 1 : 0) : 
                 (y == 3'b100)? (w? 1 : 1) : 
                 (y == 3'b011)? (w? 1 : 0) : 
                 (y == 3'b010)? (w? 1 : 0) : 
                 (y == 3'b001)? (w? 0 : 1) : 
                 (y == 3'b000)? (w? 0 : 0) : 0;

    // or using case statement
    // always @(*)
    // begin
    //     case (y)
    //         3'b000: Y1 = w? 0 : 0;
    //         3'b001: Y1 = w? 0 : 1;
    //         3'b010: Y1 = w? 1 : 0;
    //         3'b011: Y1 = w? 1 : 0;
    //         3'b100: Y1 = w? 1 : 1;
    //         3'b101: Y1 = w? 1 : 0;
    //         default: Y1 = 0;
    //     endcase
    // end

endmodule