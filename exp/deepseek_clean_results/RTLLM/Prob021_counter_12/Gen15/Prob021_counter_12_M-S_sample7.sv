module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

always @(posedge clk)
    out <= !rst_n ? 4'b0 : valid_count ? out + 1'b1 : out;

endmodule