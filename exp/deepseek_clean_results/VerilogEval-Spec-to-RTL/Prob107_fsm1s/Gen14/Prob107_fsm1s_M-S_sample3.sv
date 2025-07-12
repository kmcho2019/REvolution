module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    always @(posedge clk) begin
        if (reset) out <= 1'b1;
        else if (!in) out <= ~out;
    end

endmodule