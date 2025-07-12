module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// State definitions
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101,
    S6 = 3'b110,
    S7 = 3'b111
} state, next_state;

// Output logic
logic disc_next, flag_next, err_next;

always_comb begin
    case (state)
        S5: begin
            // If in S5 (five '1's), the next bit should be discarded
            disc_next = 1'b1;
            flag_next = 1'b0;
            err_next = 1'b0;
        end
        S6: begin
            // If in S6 (six '1's), check the next bit for flag or error
            if (in == 1'b0) begin
                // Error, more than six '1's
                disc_next = 1'b0;
                flag_next = 1'b0;
                err_next = 1'b1;
            end else begin
                // Flag condition met
                disc_next = 1'b0;
                flag_next = 1'b1;
                err_next = 1'b0;
            end
        end
        S7: begin
            // Already in error state, stay in error
            disc_next = 1'b0;
            flag_next = 1'b0;
            err_next = 1'b1;
        end
        default: begin
            // Default: No output asserted
            disc_next = 1'b0;
            flag_next = 1'b0;
            err_next = 1'b0;
        end
    endcase
end

always_comb begin
    case (state)
        S0: begin
            if (in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (in == 1'b1) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if (in == 1'b1) begin
                next_state = S3;
            end else begin
                next_state = S0;
            end
        end
        S3: begin
            if (in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (in == 1'b1) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (in == 1'b0) begin
                next_state = S0; // Discard bit, reset sequence
            end else begin
                next_state = S6; // Proceed to check for flag or error
            end
        end
        S6: begin
            if (in == 1'b0) begin
                next_state = S7; // Error state
            end else begin
                next_state = S7; // Flag condition met, next bit would cause error
            end
        end
        S7: begin
            if (in == 1'b0) begin
                next_state = S0;
            end else begin
                next_state = S7; // Stay in error state
            end
        end
        default: next_state = S0;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        disc <= disc_next;
        flag <= flag_next;
        err <= err_next;
    end
end

endmodule