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
    reg [9:0] lut_next_state [2**10];
    reg [1:0] lut_out [2**10];

    // Initialize the lookup table
    integer i;
    always @(*) begin
        for (i = 0; i < 2**10; i++) begin
            // S0
            if (i == 0) begin
                lut_next_state[i] = in? 10'b0000000001 : 10'b0000000001;
                lut_out[i] = 2'b00;
            end
            // S1
            else if (i == 1) begin
                lut_next_state[i] = in? 10'b0000000010 : 10'b0000000001;
                lut_out[i] = 2'b00;
            end
            // S2
            else if (i == 2) begin
                lut_next_state[i] = in? 10'b0000000100 : 10'b0000000001;
                lut_out[i] = 2'b00;
            end
            // S3
            else if (i == 3) begin
                lut_next_state[i] = in? 10'b0000001000 : 10'b0000000001;
                lut_out[i] = 2'b00;
            end
            // S4
            else if (i == 4) begin
                lut_next_state[i] = in? 10'b0000010000 : 10'b0000000001;
                lut_out[i] = 2'b00;
            end
            // S5
            else if (i == 5) begin
                lut_next_state[i] = in? 10'b0000100000 : 10'b0000100000;
                lut_out[i] = 2'b00;
            end
            // S6
            else if (i == 6) begin
                lut_next_state[i] = in? 10'b0001000000 : 10'b0010000000;
                lut_out[i] = 2'b00;
            end
            // S7
            else if (i == 7) begin
                lut_next_state[i] = in? 10'b0001000000 : 10'b0000000001;
                lut_out[i] = 2'b01;
            end
            // S8
            else if (i == 8) begin
                lut_next_state[i] = in? 10'b0000000001 : 10'b0000000001;
                lut_out[i] = 2'b10;
            end
            // S9
            else if (i == 9) begin
                lut_next_state[i] = in? 10'b0000000001 : 10'b0000000001;
                lut_out[i] = 2'b11;
            end
            // Default
            else begin
                lut_next_state[i] = 10'b0000000001;
                lut_out[i] = 2'b00;
            end
        end
    end

    // Use the lookup table to determine the next state and output values
    always @(*) begin
        next_state_reg = lut_next_state[state];
        out1_reg = lut_out[state][1];
        out2_reg = lut_out[state][0];
    end

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule