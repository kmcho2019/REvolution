module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Concatenate A and B to form mux selector
    wire [3:0] mux_sel = {A, B};
    
    // 4:1 mux implementation
    assign z = (mux_sel == 4'b0000) ? 1'b1 :  // A=00, B=00
               (mux_sel == 4'b0101) ? 1'b1 :  // A=01, B=01
               (mux_sel == 4'b1010) ? 1'b1 :  // A=10, B=10
               (mux_sel == 4'b1111) ? 1'b1 :  // A=11, B=11
               1'b0;                          // All other cases
endmodule