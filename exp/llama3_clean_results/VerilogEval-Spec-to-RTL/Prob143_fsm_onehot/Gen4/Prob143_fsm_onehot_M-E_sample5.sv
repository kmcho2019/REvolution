module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    reg [9:0] next_state_reg;
    reg out1_reg;
    reg out2_reg;

    // Define the lookup table
    reg [9:0] lut_next_state [2][10];
    reg [1:0] lut_output [2][10];

    // Initialize the lookup table
    always @(*) begin
        lut_next_state[0][0] = 10'b1; // S0
        lut_next_state[0][1] = 10'b1; // S1
        lut_next_state[0][2] = 10'b1; // S2
        lut_next_state[0][3] = 10'b1; // S3
        lut_next_state[0][4] = 10'b1; // S4
        lut_next_state[0][5] = 10'b100000000; // S8
        lut_next_state[0][6] = 10'b1000000000; // S9
        lut_next_state[0][7] = 10'b1; // S0
        lut_next_state[0][8] = 10'b1; // S0
        lut_next_state[0][9] = 10'b1; // S0

        lut_next_state[1][0] = 10'b10; // S1
        lut_next_state[1][1] = 10'b100; // S2
        lut_next_state[1][2] = 10'b1000; // S3
        lut_next_state[1][3] = 10'b10000; // S4
        lut_next_state[1][4] = 10'b100000; // S5
        lut_next_state[1][5] = 10'b1000000; // S6
        lut_next_state[1][6] = 10'b10000000; // S7
        lut_next_state[1][7] = 10'b10000000; // S7
        lut_next_state[1][8] = 10'b10; // S1
        lut_next_state[1][9] = 10'b10; // S1

        lut_output[0][0] = 2'b00; // S0
        lut_output[0][1] = 2'b00; // S1
        lut_output[0][2] = 2'b00; // S2
        lut_output[0][3] = 2'b00; // S3
        lut_output[0][4] = 2'b00; // S4
        lut_output[0][5] = 2'b10; // S8
        lut_output[0][6] = 2'b11; // S9
        lut_output[0][7] = 2'b01; // S7
        lut_output[0][8] = 2'b10; // S8
        lut_output[0][9] = 2'b11; // S9

        lut_output[1][0] = 2'b00; // S1
        lut_output[1][1] = 2'b00; // S2
        lut_output[1][2] = 2'b00; // S3
        lut_output[1][3] = 2'b00; // S4
        lut_output[1][4] = 2'b00; // S5
        lut_output[1][5] = 2'b00; // S6
        lut_output[1][6] = 2'b01; // S7
        lut_output[1][7] = 2'b01; // S7
        lut_output[1][8] = 2'b10; // S1
        lut_output[1][9] = 2'b11; // S1
    end

    // Use the lookup table to determine the next state and output values
    always @(*) begin
        next_state_reg = 10'b0;
        out1_reg = 1'b0;
        out2_reg = 1'b0;

        // Check each state bit individually
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                next_state_reg = next_state_reg | lut_next_state[in][i];
                out1_reg = out1_reg | lut_output[in][i][1];
                out2_reg = out2_reg | lut_output[in][i][0];
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule