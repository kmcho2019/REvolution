module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    parameter [7:0] S0 = 8'b00000001,  // 0 consecutive 1s
                   S1 = 8'b00000010,  // 1 consecutive 1
                   S2 = 8'b00000100,  // 2 consecutive 1s
                   S3 = 8'b00001000,  // 3 consecutive 1s
                   S4 = 8'b00010000,  // 4 consecutive 1s
                   S5 = 8'b00100000,  // 5 consecutive 1s
                   S6 = 8'b01000000,  // 6 consecutive 1s
                   S7 = 8'b10000000;  // 7+ consecutive 1s (error)

    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Clear outputs unless set in this cycle
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            if (in) begin
                case (state)
                    S0: state <= S1;
                    S1: state <= S2;
                    S2: state <= S3;
                    S3: state <= S4;
                    S4: state <= S5;
                    S5: state <= S6;
                    S6: state <= S7;
                    S7: begin
                        state <= S7;
                        err <= 1;
                    end
                endcase
            end else begin
                // Check for outputs when seeing a 0
                if (state == S5) disc <= 1;
                if (state == S6) flag <= 1;
                if (state == S7) err <= 1;
                state <= S0;
            end
        end
    end

endmodule