module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Create a 2-bit selector by concatenating A and B
    wire [1:0] sel = A ^ B;  // 00 when equal, other values when not
    
    // 4:1 mux implementation
    assign z = (sel == 2'b00) ? 1'b1 : 
               (sel == 2'b01) ? 1'b0 :
               (sel == 2'b10) ? 1'b0 :
               1'b0;
endmodule