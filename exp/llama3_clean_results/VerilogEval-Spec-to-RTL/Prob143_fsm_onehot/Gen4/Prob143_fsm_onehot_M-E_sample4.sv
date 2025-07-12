module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    // Define the state transition LUT
    wire [9:0] next_state_reg;
    reg [9:0] next_state_LUT [1024:0]; // 2^10 possible state combinations

    // Initialize the state transition LUT
    initial begin
        next_state_LUT[0] = 10'b1; // S0
        next_state_LUT[1] = 10'b10; // S1
        next_state_LUT[2] = 10'b100; // S2
        next_state_LUT[3] = 10'b1000; // S3
        next_state_LUT[4] = 10'b10000; // S4
        next_state_LUT[5] = 10'b100000; // S5
        next_state_LUT[6] = 10'b1000000; // S6
        next_state_LUT[7] = 10'b10000000; // S7
        next_state_LUT[8] = 10'b100000000; // S8
        next_state_LUT[9] = 10'b1000000000; // S9

        // Fill in the rest of the LUT with don't care values
        for (int i = 10; i < 1024; i++) begin
            next_state_LUT[i] = 10'b0;
        end
    end

    // Define the output logic LUT
    wire [1:0] output_reg;
    reg [1:0] output_LUT [1024:0]; // 2^10 possible state combinations

    // Initialize the output logic LUT
    initial begin
        output_LUT[0] = 2'b00; // S0
        output_LUT[1] = 2'b00; // S1
        output_LUT[2] = 2'b00; // S2
        output_LUT[3] = 2'b00; // S3
        output_LUT[4] = 2'b00; // S4
        output_LUT[5] = 2'b00; // S5
        output_LUT[6] = 2'b00; // S6
        output_LUT[7] = 2'b01; // S7
        output_LUT[8] = 2'b10; // S8
        output_LUT[9] = 2'b11; // S9

        // Fill in the rest of the LUT with don't care values
        for (int i = 10; i < 1024; i++) begin
            output_LUT[i] = 2'b00;
        end
    end

    // Use the LUTs to determine the next state and output values
    always @(*) begin
        // Calculate the index into the LUTs
        integer index;
        if (in) begin
            // If the input is 1, use the second half of the LUT
            index = state + 512;
        end else begin
            // If the input is 0, use the first half of the LUT
            index = state;
        end

        // Look up the next state and output values in the LUTs
        next_state_reg = next_state_LUT[index];
        output_reg = output_LUT[index];
    end

    assign next_state = next_state_reg;
    assign out1 = output_reg[0];
    assign out2 = output_reg[1];

endmodule