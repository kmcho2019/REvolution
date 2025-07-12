module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    reg [1:0] next_state_reg;
    reg out_reg;

    // Define the lookup table (LUT) for state transitions and outputs
    reg [1:0] lut_ns [4]; // Next state LUT
    reg [0:0] lut_out [4]; // Output LUT

    initial begin
        // Initialize the LUT with state transitions and outputs
        lut_ns[0] = 2'b00; lut_out[0] = 1'b0; // State A, in=0
        lut_ns[1] = 2'b01; lut_out[1] = 1'b0; // State A, in=1
        lut_ns[2] = 2'b10; lut_out[2] = 1'b0; // State B, in=0
        lut_ns[3] = 2'b01; lut_out[3] = 1'b0; // State B, in=1
        lut_ns[4] = 2'b00; lut_out[4] = 1'b0; // State C, in=0
        lut_ns[5] = 2'b11; lut_out[5] = 1'b0; // State C, in=1
        lut_ns[6] = 2'b10; lut_out[6] = 1'b1; // State D, in=0
        lut_ns[7] = 2'b01; lut_out[7] = 1'b1; // State D, in=1
    end

    always @(*) begin
        // Determine the index into the LUT based on the current state and input
        case(state)
            2'b00: begin
                if (!in) begin
                    next_state_reg = lut_ns[0];
                    out_reg = lut_out[0];
                end else begin
                    next_state_reg = lut_ns[1];
                    out_reg = lut_out[1];
                end
            end
            2'b01: begin
                if (!in) begin
                    next_state_reg = lut_ns[2];
                    out_reg = lut_out[2];
                end else begin
                    next_state_reg = lut_ns[3];
                    out_reg = lut_out[3];
                end
            end
            2'b10: begin
                if (!in) begin
                    next_state_reg = lut_ns[4];
                    out_reg = lut_out[4];
                end else begin
                    next_state_reg = lut_ns[5];
                    out_reg = lut_out[5];
                end
            end
            2'b11: begin
                if (!in) begin
                    next_state_reg = lut_ns[6];
                    out_reg = lut_out[6];
                end else begin
                    next_state_reg = lut_ns[7];
                    out_reg = lut_out[7];
                end
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule