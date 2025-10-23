module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_shifted;
    wire [511:0] right_shifted;
    wire [511:0] next_state;

    // Left shifted q with 0 at LSB (right end)
    assign left_shifted = {q[510:0], 1'b0};

    // Right shifted q with 0 at MSB (left end)
    assign right_shifted = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors (Rule 90)
    assign next_state = left_shifted ^ right_shifted;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule