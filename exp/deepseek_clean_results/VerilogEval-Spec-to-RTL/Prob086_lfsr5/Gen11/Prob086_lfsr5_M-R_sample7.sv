module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

wire [4:0] next_q;

// Combinational logic for next state
assign next_q = reset ? 5'b00001 : {q[0], q[4], q[3] ^ q[0], q[2], q[1]};

// Sequential elements
dff #(5) lfsr_reg (
    .clk(clk),
    .d(next_q),
    .q(q)
);

endmodule

// Simple D flip-flop module
module dff #(parameter WIDTH=1) (
    input clk,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    q <= d;
end

endmodule