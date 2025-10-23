module TopModule (
    input a,
    input b,
    output out
);
    // LUT-based XNOR implementation
    wire [1:0] sel = {a,b};
    
    // Truth table:
    // 00 -> 1
    // 01 -> 0
    // 10 -> 0
    // 11 -> 1
    assign out = (sel == 2'b00) ? 1'b1 :
                (sel == 2'b01) ? 1'b0 :
                (sel == 2'b10) ? 1'b0 :
                                 1'b1;
endmodule