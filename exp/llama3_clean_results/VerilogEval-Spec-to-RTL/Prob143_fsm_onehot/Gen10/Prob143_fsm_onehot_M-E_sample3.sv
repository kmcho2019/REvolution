module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [9:0] next_state_array [2][10];
    reg [1:0] out_array [2][10];

    // Initialize next state and output arrays
    initial begin
        next_state_array[0][0] = 10'b1; // S0
        next_state_array[1][0] = 10'b10; // S1
        next_state_array[0][1] = 10'b1; // S1
        next_state_array[1][1] = 10'b100; // S2
        next_state_array[0][2] = 10'b1; // S2
        next_state_array[1][2] = 10'b1000; // S3
        next_state_array[0][3] = 10'b1; // S3
        next_state_array[1][3] = 10'b10000; // S4
        next_state_array[0][4] = 10'b1; // S4
        next_state_array[1][4] = 10'b100000; // S5
        next_state_array[0][5] = 10'b1000000000; // S5
        next_state_array[1][5] = 10'b1000000; // S6
        next_state_array[0][6] = 10'b100000000; // S6
        next_state_array[1][6] = 10'b10000000; // S7
        next_state_array[0][7] = 10'b1; // S7
        next_state_array[1][7] = 10'b10000000; // S7
        next_state_array[0][8] = 10'b1; // S8
        next_state_array[1][8] = 10'b10; // S1
        next_state_array[0][9] = 10'b1; // S9
        next_state_array[1][9] = 10'b10; // S1

        out_array[0][0] = 2'b00; // S0
        out_array[1][0] = 2'b00; // S0
        out_array[0][1] = 2'b00; // S1
        out_array[1][1] = 2'b00; // S1
        out_array[0][2] = 2'b00; // S2
        out_array[1][2] = 2'b00; // S2
        out_array[0][3] = 2'b00; // S3
        out_array[1][3] = 2'b00; // S3
        out_array[0][4] = 2'b00; // S4
        out_array[1][4] = 2'b00; // S4
        out_array[0][5] = 2'b00; // S5
        out_array[1][5] = 2'b00; // S5
        out_array[0][6] = 2'b10; // S6
        out_array[1][6] = 2'b00; // S6
        out_array[0][7] = 2'b01; // S7
        out_array[1][7] = 2'b01; // S7
        out_array[0][8] = 2'b10; // S8
        out_array[1][8] = 2'b10; // S8
        out_array[0][9] = 2'b11; // S9
        out_array[1][9] = 2'b11; // S9
    end

    always @(*) begin
        next_state = 10'b0; // Initialize next_state to zero
        out1 = 1'b0; // Initialize out1 to zero
        out2 = 1'b0; // Initialize out2 to zero

        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin // Check each state individually
                next_state = next_state | next_state_array[in][i];
                {out2, out1} = out_array[in][i];
            end
        end
    end

endmodule