module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] q_shift_left, q_shift_right;
wire [511:0] next_q;

// Calculate shifted versions with boundary conditions
always @(*) begin
    q_shift_left = {q[510:0], 1'b0};  // Left shift (right neighbor)
    q_shift_right = {1'b0, q[511:1]}; // Right shift (left neighbor)
end

// Compute next state by XORing neighbors
assign next_q = q_shift_right ^ q_shift_left;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule