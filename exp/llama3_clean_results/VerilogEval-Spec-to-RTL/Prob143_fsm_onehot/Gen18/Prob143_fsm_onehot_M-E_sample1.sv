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

    // Define the lookup table (LUT)
    reg [9:0] lut_state [10][2];
    reg [1:0] lut_output [10][2];

    // Initialize the LUT
    initial begin
        // S0
        lut_state[0][0] = 10'b1;
        lut_state[0][1] = 10'b10;
        lut_output[0][0] = 2'b00;
        lut_output[0][1] = 2'b00;

        // S1
        lut_state[1][0] = 10'b1;
        lut_state[1][1] = 10'b100;
        lut_output[1][0] = 2'b00;
        lut_output[1][1] = 2'b00;

        // S2
        lut_state[2][0] = 10'b1;
        lut_state[2][1] = 10'b1000;
        lut_output[2][0] = 2'b00;
        lut_output[2][1] = 2'b00;

        // S3
        lut_state[3][0] = 10'b1;
        lut_state[3][1] = 10'b10000;
        lut_output[3][0] = 2'b00;
        lut_output[3][1] = 2'b00;

        // S4
        lut_state[4][0] = 10'b1;
        lut_state[4][1] = 10'b100000;
        lut_output[4][0] = 2'b00;
        lut_output[4][1] = 2'b00;

        // S5
        lut_state[5][0] = 10'b100000000;
        lut_state[5][1] = 10'b1000000;
        lut_output[5][0] = 2'b00;
        lut_output[5][1] = 2'b00;

        // S6
        lut_state[6][0] = 10'b1000000000;
        lut_state[6][1] = 10'b10000000;
        lut_output[6][0] = 2'b00;
        lut_output[6][1] = 2'b00;

        // S7
        lut_state[7][0] = 10'b1;
        lut_state[7][1] = 10'b10000000;
        lut_output[7][0] = 2'b01;
        lut_output[7][1] = 2'b01;

        // S8
        lut_state[8][0] = 10'b1;
        lut_state[8][1] = 10'b10;
        lut_output[8][0] = 2'b10;
        lut_output[8][1] = 2'b10;

        // S9
        lut_state[9][0] = 10'b1;
        lut_state[9][1] = 10'b10;
        lut_output[9][0] = 2'b11;
        lut_output[9][1] = 2'b11;
    end

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        // Find the current state
        reg [9:0] current_state;
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                current_state = i;
            end
        end

        // Determine the next state and output values
        if (in) begin
            next_state_reg = lut_state[current_state][1];
            {out2_reg, out1_reg} = lut_output[current_state][1];
        end else begin
            next_state_reg = lut_state[current_state][0];
            {out2_reg, out1_reg} = lut_output[current_state][0];
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule