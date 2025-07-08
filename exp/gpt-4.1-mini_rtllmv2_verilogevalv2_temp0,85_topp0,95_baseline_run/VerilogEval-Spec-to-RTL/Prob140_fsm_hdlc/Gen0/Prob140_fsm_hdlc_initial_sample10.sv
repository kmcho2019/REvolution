module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [3:0] {
        S0       = 4'd0, // 0 consecutive ones
        S1       = 4'd1,
        S2       = 4'd2,
        S3       = 4'd3,
        S4       = 4'd4,
        S5       = 4'd5,
        S6       = 4'd6,
        S_DISC   = 4'd7, // disc output asserted
        S_FLAG   = 4'd8, // flag output asserted
        S_ERR    = 4'd9  // error output asserted
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        // Default next state
        next_state = state;

        case(state)
            S0: begin
                if (in == 1'b1) next_state = S1;
                else            next_state = S0;
            end

            S1: begin
                if (in == 1'b1) next_state = S2;
                else            next_state = S0;
            end

            S2: begin
                if (in == 1'b1) next_state = S3;
                else            next_state = S0;
            end

            S3: begin
                if (in == 1'b1) next_state = S4;
                else            next_state = S0;
            end

            S4: begin
                if (in == 1'b1) next_state = S5;
                else            next_state = S0;
            end

            S5: begin
                if (in == 1'b1) next_state = S6;
                else            next_state = S_DISC; // disc bit detected (zero after 5 ones)
            end

            S6: begin
                if (in == 1'b1) next_state = S_ERR;  // 7 consecutive ones => error
                else            next_state = S_FLAG; // flag detected (zero after 6 ones)
            end

            S_DISC: begin
                // After disc output cycle, return to S0 (input handled)
                if (in == 1'b1) next_state = S1;
                else            next_state = S0;
            end

            S_FLAG: begin
                // After flag output cycle, return to S0 (input handled)
                if (in == 1'b1) next_state = S1;
                else            next_state = S0;
            end

            S_ERR: begin
                // Remain in error until reset
                next_state = S_ERR;
            end

            default: next_state = S0;
        endcase
    end

    // State update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore outputs depend only on state)
    always @(*) begin
        disc = 1'b0;
        flag = 1'b0;
        err  = 1'b0;

        case(state)
            S_DISC: disc = 1'b1;
            S_FLAG: flag = 1'b1;
            S_ERR:  err  = 1'b1;
            default: ; // no outputs asserted
        endcase
    end

endmodule