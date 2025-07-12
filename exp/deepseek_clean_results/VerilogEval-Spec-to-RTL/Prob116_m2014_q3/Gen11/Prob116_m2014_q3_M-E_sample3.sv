module TopModule(
    input [3:0] x,  // x[3] is MSB, x[0] is LSB
    output f
);
    wire [1:0] sel = x[3:2];  // Use x[3] and x[2] as select bits
    wire f00, f01, f10, f11;
    
    // Implement each quadrant separately
    assign f00 = (x[1] & ~x[0]) ? 1'b0 : 1'b0;  // All 0s in this quadrant
    assign f01 = (x[1] ^ x[0]) ? 1'b0 : 1'b1;    // Diagonal pattern
    assign f10 = (x[1] | x[0]) ? 1'b1 : 1'b1;    // Mostly 1s
    assign f11 = (x[1] & x[0]) ? 1'b1 : 1'b0;    // AND pattern
    
    // 4:1 mux to select the appropriate output
    assign f = (sel == 2'b00) ? f00 :
               (sel == 2'b01) ? f01 :
               (sel == 2'b10) ? f10 :
               f11;
endmodule