module TopModule(clk, reset, in, disc, flag, err);
    input clk, reset, in;
    output disc, flag, err;

    reg [2:0] state; // State register
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

    always @(posedge clk) begin
        if (reset) begin // Reset the state machine
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            case (state)
                S0: begin
                    if (in) begin
                        state <= S1;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                S1: begin
                    if (in) begin
                        state <= S2;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                S2: begin
                    if (in) begin
                        state <= S3;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                S3: begin
                    if (in) begin
                        state <= S4;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                S4: begin
                    if (in) begin
                        state <= S5;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                S5: begin
                    if (in) begin
                        state <= S6;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end else begin
                        state <= S0;
                        disc <= 1; // Signal to discard the previous bit
                        flag <= 0;
                        err <= 0;
                    end
                end
                S6: begin
                    if (in) begin
                        state <= S7;
                        disc <= 0;
                        flag <= 0;
                        err <= 1; // Signal error for 7 or more consecutive ones
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 1; // Signal flag for 6 consecutive ones followed by a zero
                        err <= 0;
                    end
                end
                S7: begin
                    if (in) begin
                        state <= S7;
                        disc <= 0;
                        flag <= 0;
                        err <= 1; // Continue signaling error
                    end else begin
                        state <= S0;
                        disc <= 0;
                        flag <= 0;
                        err <= 0;
                    end
                end
                default: state <= S0;
            endcase
        end
    end
endmodule