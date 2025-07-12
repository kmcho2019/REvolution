module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded state register (states 0-7)
    reg [7:0] state;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001;  // State 0 (one-hot)
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (only update when needed)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            if (in) begin
                // Shift left (count up) unless at max state
                if (state != 8'b10000000) begin
                    state <= state << 1;
                end
            end else begin
                state <= 8'b00000001;  // Reset to state 0
            end

            // Output generation (registered)
            case (state)
                8'b00100000: disc <= in == 0;  // State 5
                8'b01000000: flag <= in == 0;  // State 6
                8'b10000000: err <= in == 1;   // State 7
                default: ;  // No outputs for other states
            endcase
        end
    end

endmodule