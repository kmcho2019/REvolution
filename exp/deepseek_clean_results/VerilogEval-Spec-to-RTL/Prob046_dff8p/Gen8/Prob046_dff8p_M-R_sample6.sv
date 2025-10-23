module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

wire [7:0] next_q;

// Combinational logic for next state
assign next_q = reset ? 8'h34 : d;

// Sequential element (negative edge triggered)
always @(negedge clk) begin
    q <= next_q;
end

endmodule