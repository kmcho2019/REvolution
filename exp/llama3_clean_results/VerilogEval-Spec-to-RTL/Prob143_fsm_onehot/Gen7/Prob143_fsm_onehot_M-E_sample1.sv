module TopModule(
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    reg [3:0] current_state;
    reg [9:0] lut_next_state [10:0][1:0];
    reg [1:0] lut_output [10:0][1:0];

    // Initialize the LUT
    initial begin
        // S0
        lut_next_state[0][0] = 10'b1;
        lut_next_state[0][1] = 10'b10;
        lut_output[0][0] = 2'b00;
        lut_output[0][1] = 2'b00;

        // S1
        lut_next_state[1][0] = 10'b1;
        lut_next_state[1][1] = 10'b100;
        lut_output[1][0] = 2'b00;
        lut_output[1][1] = 2'b00;

        // S2
        lut_next_state[2][0] = 10'b1;
        lut_next_state[2][1] = 10'b1000;
        lut_output[2][0] = 2'b00;
        lut_output[2][1] = 2'b00;

        // S3
        lut_next_state[3][0] = 10'b1;
        lut_next_state[3][1] = 10'b10000;
        lut_output[3][0] = 2'b00;
        lut_output[3][1] = 2'b00;

        // S4
        lut_next_state[4][0] = 10'b1;
        lut_next_state[4][1] = 10'b100000;
        lut_output[4][0] = 2'b00;
        lut_output[4][1] = 2'b00;

        // S5
        lut_next_state[5][0] = 10'b100000000;
        lut_next_state[5][1] = 10'b1000000;
        lut_output[5][0] = 2'b00;
        lut_output[5][1] = 2'b00;

        // S6
        lut_next_state[6][0] = 10'b1000000000;
        lut_next_state[6][1] = 10'b10000000;
        lut_output[6][0] = 2'b00;
        lut_output[6][1] = 2'b00;

        // S7
        lut_next_state[7][0] = 10'b1;
        lut_next_state[7][1] = 10'b100000000;
        lut_output[7][0] = 2'b01;
        lut_output[7][1] = 2'b01;

        // S8
        lut_next_state[8][0] = 10'b1;
        lut_next_state[8][1] = 10'b10;
        lut_output[8][0] = 2'b10;
        lut_output[8][1] = 2'b10;

        // S9
        lut_next_state[9][0] = 10'b1;
        lut_next_state[9][1] = 10'b10;
        lut_output[9][0] = 2'b11;
        lut_output[9][1] = 2'b11;
    end

    // Decode the one-hot state to a binary index
    always @(*) begin
        current_state = 4'b0;
        if (state[0]) current_state = 4'b0001;
        else if (state[1]) current_state = 4'b0010;
        else if (state[2]) current_state = 4'b0011;
        else if (state[3]) current_state = 4'b0100;
        else if (state[4]) current_state = 4'b0101;
        else if (state[5]) current_state = 4'b0110;
        else if (state[6]) current_state = 4'b0111;
        else if (state[7]) current_state = 4'b1000;
        else if (state[8]) current_state = 4'b1001;
        else if (state[9]) current_state = 4'b1010;
    end

    // Use the LUT to determine the next state and output values
    always @(*) begin
        next_state = lut_next_state[current_state][in];
        out1 = lut_output[current_state][in][0];
        out2 = lut_output[current_state][in][1];
    end

endmodule