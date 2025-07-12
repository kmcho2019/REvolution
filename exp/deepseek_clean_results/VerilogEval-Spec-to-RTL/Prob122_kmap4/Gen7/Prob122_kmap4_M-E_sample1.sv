module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Mux implementation of K-map
    reg out_reg;
    
    always @(*) begin
        case ({c, a})
            2'b00: out_reg = ~(b ^ d);  // Pattern for c=0,a=0
            2'b01: out_reg = b ^ d;     // Pattern for c=0,a=1
            2'b10: out_reg = b ^ d;     // Pattern for c=1,a=0
            2'b11: out_reg = ~(b ^ d);  // Pattern for c=1,a=1
            default: out_reg = 1'b0;
        endcase
    end
    
    assign out = out_reg;
endmodule