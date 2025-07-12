module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Left neighbors with zero padding at LSB (bit 0's left neighbor is 0)
    assign left_shifted  = {q[510:0], 1'b0};
    // Right neighbors with zero padding at MSB (bit 511's right neighbor is 0)
    assign right_shifted = {1'b0, q[511:1]};

    // Next state: XOR of left and right neighbors for each bit
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule