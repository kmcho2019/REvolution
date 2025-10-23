`default_nettype none
module TopModule(output wire out);
    reg out_reg;
    always @(*) begin
        out_reg = 1'b0;
    end
    assign out = out_reg;
endmodule
`default_nettype wire