module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Form 3-bit address from inputs
    wire [2:0] addr = {a, b, c};
    
    // 8-entry lookup table matching Karnaugh map
    reg out_reg;
    always @(*) begin
        case(addr)
            3'b000: out_reg = 1'b0;
            default: out_reg = 1'b1;
        endcase
    end
    
    assign out = out_reg;
endmodule