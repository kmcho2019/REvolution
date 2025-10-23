module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define states
    enum {S0, S1, S2, S3, S4, S5, S6, S7, S_Disc} state, next_state;

    // Output signals
    reg disc_reg, flag_reg, err_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc_reg <= 0;
            flag_reg <= 0;
            err_reg <= 0;
        end else begin
            state <= next_state;
            disc_reg <= (state == S_Disc);
            flag_reg <= (state == S6);
            err_reg <= (state == S7);
        end
    end

    always @(*) begin
        case(state)
            S0: begin
                if (in) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (in) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (in) next_state = S3;
                else next_state = S0;
            end
            S3: begin
                if (in) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                if (in) next_state = S5;
                else next_state = S0;
            end
            S5: begin
                if (in) next_state = S7; // Error, too many 1s
                else next_state = S_Disc; // Discard the bit
            end
            S6: begin
                if (in) next_state = S7; // Error, too many 1s
                else next_state = S0; // Reset state
            end
            S7: begin
                if (in) next_state = S7; // Stay in error state
                else next_state = S0; // Reset state on seeing 0
            end
            S_Disc: begin
                next_state = S0; // Reset state after discarding
            end
            default: next_state = S0; // Default to initial state
        endcase
    end

    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule