module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (S0-S7)
    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001;  // S0
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions and output generation
            case (1'b1)
                state[0]: begin // S0
                    if (in) state <= 8'b00000010; // S1
                    else state <= 8'b00000001;     // S0
                end
                state[1]: begin // S1
                    if (in) state <= 8'b00000100; // S2
                    else state <= 8'b00000001;    // S0
                end
                state[2]: begin // S2
                    if (in) state <= 8'b00001000; // S3
                    else state <= 8'b00000001;    // S0
                end
                state[3]: begin // S3
                    if (in) state <= 8'b00010000; // S4
                    else state <= 8'b00000001;    // S0
                end
                state[4]: begin // S4
                    if (in) state <= 8'b00100000; // S5
                    else state <= 8'b00000001;    // S0
                end
                state[5]: begin // S5
                    if (in) state <= 8'b01000000; // S6
                    else begin
                        state <= 8'b00000001;    // S0
                        disc <= 1;               // Discard signal
                    end
                end
                state[6]: begin // S6
                    if (in) state <= 8'b10000000; // S7 (error)
                    else begin
                        state <= 8'b00000001;    // S0
                        flag <= 1;              // Flag signal
                    end
                end
                state[7]: begin // S7 (error state)
                    if (in) begin
                        state <= 8'b10000000;    // Stay in error
                        err <= 1;               // Error signal
                    end else begin
                        state <= 8'b00000001;    // S0
                        err <= 1;               // Error signal
                    end
                end
                default: state <= 8'b00000001;   // S0
            endcase
        end
    end

endmodule