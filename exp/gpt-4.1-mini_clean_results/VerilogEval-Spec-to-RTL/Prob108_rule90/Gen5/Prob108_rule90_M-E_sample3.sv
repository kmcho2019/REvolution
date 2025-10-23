module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Left neighbors: q shifted left by 1, with zero on LSB
    assign left_shifted = {q[510:0], 1'b0};
    // Right neighbors: q shifted right by 1, with zero on MSB
    assign right_shifted = {1'b0, q[511:1]};
    // Next state: XOR of left and right neighbors
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule