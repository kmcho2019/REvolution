module TopModule (
    input clk,
    input in,
    output reg out
);

    always @(posedge clk) begin
        if (in) out <= ~out;
        // else hold (implicit in FF behavior)
    end

endmodule