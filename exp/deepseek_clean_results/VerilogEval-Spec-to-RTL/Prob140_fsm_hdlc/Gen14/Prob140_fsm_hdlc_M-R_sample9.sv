module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states
    reg [7:0] state;
    parameter S0 = 8'b00000001,
             S1 = 8'b00000010,
             S2 = 8'b00000100,
             S3 = 8'b00001000,
             S4 = 8'b00010000,
             S5 = 8'b00100000,
             S6 = 8'b01000000,
             SERR = 8'b10000000;

    // Next state and output logic
    reg [7:0] next_state;
    reg next_disc, next_flag, next_err;

    // Continuous assignments for outputs
    assign disc = next_disc;
    assign flag = next_flag;
    assign err = next_err;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            next_disc <= 0;
            next_flag <= 0;
            next_err <= 0;
        end else begin
            state <= next_state;
            next_disc <= 0;
            next_flag <= 0;
            next_err <= 0;

            case (state)
                S0: if (in) next_state <= S1;
                    else next_state <= S0;
                S1: if (in) next_state <= S2;
                    else next_state <= S0;
                S2: if (in) next_state <= S3;
                    else next_state <= S0;
                S3: if (in) next_state <= S4;
                    else next_state <= S0;
                S4: if (in) next_state <= S5;
                    else next_state <= S0;
                S5: if (in) next_state <= S6;
                    else begin
                        next_state <= S0;
                        next_disc <= 1;
                    end
                S6: if (in) next_state <= SERR;
                    else begin
                        next_state <= S0;
                        next_flag <= 1;
                    end
                SERR: begin
                    next_err <= 1;
                    if (!in) next_state <= S0;
                    else next_state <= SERR;
                end
                default: next_state <= S0;
            endcase
        end
    end

endmodule