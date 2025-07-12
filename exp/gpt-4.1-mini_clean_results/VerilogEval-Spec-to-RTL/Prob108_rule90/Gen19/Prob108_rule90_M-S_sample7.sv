module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Insert zero at MSB when shifting left (left boundary zero)
    assign left_shifted = {q[510:0], 1'b0};
    // Insert zero at LSB when shifting right (right boundary zero)
    assign right_shifted = {1'b0, q[511:1]};

    // Next state is XOR of neighbors according to Rule 90
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule