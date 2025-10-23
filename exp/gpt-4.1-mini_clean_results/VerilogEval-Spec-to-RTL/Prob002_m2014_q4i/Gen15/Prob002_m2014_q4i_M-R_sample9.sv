`default_nettype none
module TopModule(output reg out);
    always @(*) begin
        out = 1'b0;
    end
endmodule
`default_nettype wire