module TopModule (
    input  wire          clk,
    input  wire          load,
    input  wire [511:0]  data,
    output reg  [511:0]  q
);

    wire [511:0] q_shift_left;
    wire [511:0] q_shift_right;
    wire [511:0] next_state;

    // Shift left by 1 with zero at LSB (left boundary q[-1] = 0)
    assign q_shift_left  = {q[510:0], 1'b0};

    // Shift right by 1 with zero at MSB (right boundary q[512] = 0)
    assign q_shift_right = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors
    assign next_state = q_shift_left ^ q_shift_right;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule