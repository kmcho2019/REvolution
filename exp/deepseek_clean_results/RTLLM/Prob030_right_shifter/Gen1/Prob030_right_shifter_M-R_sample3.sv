module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

wire [7:0] next_q;

// Continuous assignment for the shift operation
assign next_q = {d, q[7:1]};

// Clocked register update with synchronous reset
always @(posedge clk) begin
    q <= next_q;
end

// Initialization (simulation only)
initial begin
    q = 8'b0;
end

endmodule