module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Create neighbor vectors
wire [511:0] left_neighbors  = {q[510:0], 1'b0};  // Right shift (q[i-1])
wire [511:0] right_neighbors = {1'b0, q[511:1]};  // Left shift (q[i+1])

// Compute next state using vector XOR
wire [511:0] next_q = left_neighbors ^ right_neighbors;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule