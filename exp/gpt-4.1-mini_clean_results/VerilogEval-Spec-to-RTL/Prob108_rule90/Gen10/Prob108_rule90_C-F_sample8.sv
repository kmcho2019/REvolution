module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Left neighbor bits: q shifted right by 1, zero inserted at MSB (bit 511)
    assign left_shifted = {q[510:0], 1'b0};
    // Right neighbor bits: q shifted left by 1, zero inserted at LSB (bit 0)
    assign right_shifted = {1'b0, q[511:1]};
    // Rule 90 next state: XOR of left and right neighbors
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule