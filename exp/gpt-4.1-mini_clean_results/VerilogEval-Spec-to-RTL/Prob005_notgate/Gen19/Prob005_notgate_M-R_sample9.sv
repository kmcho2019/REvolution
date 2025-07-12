module TopModule (
    input  wire in,
    output wire out
);
    reg out_reg;

    always @(*) begin
        out_reg = ~in;
    end

    assign out = out_reg;
endmodule