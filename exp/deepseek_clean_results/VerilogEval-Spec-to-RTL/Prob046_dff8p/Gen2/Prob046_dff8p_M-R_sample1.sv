module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

wire [7:0] next_q;
wire [7:0] reset_val = 8'h34;

assign next_q = reset ? reset_val : d;

always @(negedge clk) begin
    q <= next_q;
end

endmodule