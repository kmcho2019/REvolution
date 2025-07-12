module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // LUT implementation using case statement
    reg out_reg;
    always @(*) begin
        case ({a,b,c})
            3'b000: out_reg = 1'b0;
            3'b001: out_reg = 1'b0;
            3'b010: out_reg = 1'b0;
            3'b011: out_reg = 1'b1;
            3'b100: out_reg = 1'b1;
            3'b101: out_reg = 1'b1;
            3'b110: out_reg = 1'b1;
            3'b111: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end
    assign out = out_reg;
endmodule