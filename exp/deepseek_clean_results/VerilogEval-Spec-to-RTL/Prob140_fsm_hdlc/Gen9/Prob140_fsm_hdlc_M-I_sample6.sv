module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded state machine (7 states: IDLE, C1, C2, C3, C4, C5, C6)
    reg [6:0] state;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b0000001;  // IDLE state
            {disc, flag, err} <= 3'b000;
        end else begin
            // Default: maintain current state and outputs
            state <= state;
            {disc, flag, err} <= 3'b000;

            if (in) begin
                case (state)
                    7'b0000001: state <= 7'b0000010; // IDLE → C1
                    7'b0000010: state <= 7'b0000100; // C1 → C2
                    7'b0000100: state <= 7'b0001000; // C2 → C3
                    7'b0001000: state <= 7'b0010000; // C3 → C4
                    7'b0010000: state <= 7'b0100000; // C4 → C5
                    7'b0100000: state <= 7'b1000000; // C5 → C6
                    7'b1000000: begin               // C6 → stay, set err
                        state <= 7'b1000000;
                        err <= 1'b1;
                    end
                    default: state <= 7'b0000001;   // Error recovery
                endcase
            end else begin
                case (state)
                    7'b0100000: disc <= 1'b1;       // C5 → discard
                    7'b1000000: flag <= 1'b1;       // C6 → flag
                    default: ;                      // No special output
                endcase
                state <= 7'b0000001;                // Return to IDLE
            end
        end
    end

endmodule