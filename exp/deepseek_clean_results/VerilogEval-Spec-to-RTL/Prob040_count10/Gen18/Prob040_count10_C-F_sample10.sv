module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational next state logic
assign next_q = (q == 4'b1001) ? 4'b0000 : q + 1'b1;

// Sequential state update with reset priority
always @(posedge clk) begin
    q <= reset ? 4'b0000 : next_q;
end

endmodule