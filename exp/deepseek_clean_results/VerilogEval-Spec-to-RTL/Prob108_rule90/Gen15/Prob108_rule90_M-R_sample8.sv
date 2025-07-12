module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Next state computation with boundary conditions (0)
wire [511:0] next_q = {1'b0, q[511:1]} ^ {q[510:0], 1'b0};

// State update with load functionality
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule