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

    // Define the LUTs for next state and outputs
    reg [9:0] next_state_lut [0:1023];
    reg [1:0] output_lut [0:1023];

    // Initialize the LUTs
    initial begin
        for (int i = 0; i < 1024; i++) begin
            next_state_lut[i] = 10'b0;
            output_lut[i] = 2'b0;
        end

        // S0
        next_state_lut[0] = (in) ? 10'b0000000010 : 10'b0000000001;
        output_lut[0] = 2'b00;

        // S1
        next_state_lut[1] = (in) ? 10'b0000000100 : 10'b0000000001;
        output_lut[1] = 2'b00;

        // S2
        next_state_lut[2] = (in) ? 10'b0000001000 : 10'b0000000001;
        output_lut[2] = 2'b00;

        // S3
        next_state_lut[3] = (in) ? 10'b0000010000 : 10'b0000000001;
        output_lut[3] = 2'b00;

        // S4
        next_state_lut[4] = (in) ? 10'b0000100000 : 10'b0000000001;
        output_lut[4] = 2'b00;

        // S5
        next_state_lut[5] = (in) ? 10'b0001000000 : 10'b1000000000;
        output_lut[5] = 2'b00;

        // S6
        next_state_lut[6] = (in) ? 10'b0010000000 : 10'b0100000000;
        output_lut[6] = 2'b00;

        // S7
        next_state_lut[7] = (in) ? 10'b0010000000 : 10'b0000000001;
        output_lut[7] = 2'b01;

        // S8
        next_state_lut[8] = (in) ? 10'b0000000010 : 10'b0000000001;
        output_lut[8] = 2'b10;

        // S9
        next_state_lut[9] = (in) ? 10'b0000000010 : 10'b0000000001;
        output_lut[9] = 2'b11;

        // Other states
        for (int i = 10; i < 1024; i++) begin
            next_state_lut[i] = 10'b0;
            output_lut[i] = 2'b0;
        end
    end

    always @(*) begin
        next_state_reg = 10'b0; // Initialize next_state to zero
        out1_reg = 1'b0; // Initialize out1 to zero
        out2_reg = 1'b0; // Initialize out2 to zero

        // Find the first set bit in the state
        for (int i = 0; i < 10; i++) begin
            if (state[i]) begin
                next_state_reg = next_state_lut[i];
                {out2_reg, out1_reg} = output_lut[i];
                break;
            end
        end
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule