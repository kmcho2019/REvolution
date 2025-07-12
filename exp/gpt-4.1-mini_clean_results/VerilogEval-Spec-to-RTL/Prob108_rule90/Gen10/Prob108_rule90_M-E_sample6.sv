module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    // Compute next state by XORing shifted versions of q with zero-padding at boundaries
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Left shift by 1, zero-padding LSB
    assign left_shifted = {q[510:0], 1'b0};
    // Right shift by 1, zero-padding MSB
    assign right_shifted = {1'b0, q[511:1]};
    // Next state is XOR of neighbors
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule