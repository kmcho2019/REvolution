module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    always @(posedge clk) begin
        out <= reset ? 1'b1 : out ^ ~in;
    end

endmodule