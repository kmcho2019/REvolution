module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Simple increment operation for better timing and area
assign next_q = q + 1'b1;

// Sequential state update with consolidated reset
always @(posedge clk) begin
    q <= reset ? 4'b0000 : next_q;
end

endmodule