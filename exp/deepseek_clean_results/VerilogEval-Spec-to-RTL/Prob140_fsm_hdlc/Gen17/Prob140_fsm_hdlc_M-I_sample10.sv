module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot state encoding: [IDLE, S1, S2, S3, S4, S5, S6, ERR]
    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001; // IDLE state
            {disc, flag, err} <= 3'b000;
        end else begin
            // Default outputs (only set when needed)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            case (1'b1)
                state[0]: // IDLE
                    if (in) state <= 8'b00000010; // S1
                    else state <= 8'b00000001; // Stay IDLE
                
                state[1]: // S1
                    if (in) state <= 8'b00000100; // S2
                    else state <= 8'b00000001; // IDLE
                
                state[2]: // S2
                    if (in) state <= 8'b00001000; // S3
                    else state <= 8'b00000001; // IDLE
                
                state[3]: // S3
                    if (in) state <= 8'b00010000; // S4
                    else state <= 8'b00000001; // IDLE
                
                state[4]: // S4
                    if (in) state <= 8'b00100000; // S5
                    else state <= 8'b00000001; // IDLE
                
                state[5]: // S5
                    if (in) state <= 8'b01000000; // S6
                    else begin
                        state <= 8'b00000001; // IDLE
                        disc <= 1; // Discard signal
                    end
                
                state[6]: // S6
                    if (in) state <= 8'b10000000; // ERR
                    else begin
                        state <= 8'b00000001; // IDLE
                        flag <= 1; // Flag signal
                    end
                
                state[7]: // ERR
                    if (!in) state <= 8'b00000001; // IDLE
                    err <= 1; // Continuous error signal
                
                default: state <= 8'b00000001; // IDLE
            endcase
        end
    end

endmodule