module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

// Compute next state by XORing left and right neighbors
// Boundary conditions: q[-1] = 0, q[512] = 0
assign next_q = {1'b0, q[511:1]} ^ {q[510:0], 1'b0};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule