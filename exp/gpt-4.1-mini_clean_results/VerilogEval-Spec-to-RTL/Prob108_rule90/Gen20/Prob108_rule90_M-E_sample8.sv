module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] next_state;

    // Calculate next_state as XOR of left and right neighbors with zero boundaries
    // Left neighbors: q shifted left by 1, padded with zero on LSB side
    wire [511:0] left_shifted  = {q[510:0], 1'b0};
    // Right neighbors: q shifted right by 1, padded with zero on MSB side
    wire [511:0] right_shifted = {1'b0, q[511:1]};

    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule