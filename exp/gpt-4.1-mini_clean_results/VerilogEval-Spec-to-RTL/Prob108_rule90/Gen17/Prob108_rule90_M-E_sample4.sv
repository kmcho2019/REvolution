module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Shift left by one bit with zero padding on right boundary
    assign left_shifted = {q[510:0], 1'b0};

    // Shift right by one bit with zero padding on left boundary
    assign right_shifted = {1'b0, q[511:1]};

    // Rule 90 next state: XOR of neighbors
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule