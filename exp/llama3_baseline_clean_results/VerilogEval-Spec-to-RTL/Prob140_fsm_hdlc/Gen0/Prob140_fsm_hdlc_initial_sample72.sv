module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // Define the states
    enum logic [2:0] {
        S_RESET = 3'b000,  // Reset state
        S_ZERO = 3'b001,   // State after seeing a zero
        S_ONE = 3'b010,    // State after seeing one '1'
        S_TWO = 3'b011,    // State after seeing two '1's
        S_THREE = 3'b100,  // State after seeing three '1's
        S_FOUR = 3'b101,   // State after seeing four '1's
        S_FIVE = 3'b110,   // State after seeing five '1's
        S_SIX = 3'b111     // State after seeing six '1's
    } state, next_state;

    // Output registers
    logic disc_reg, flag_reg, err_reg;

    // Sequential logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_RESET;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            state <= next_state;
            disc_reg <= 1'b0;
            flag_reg <= 1'b0;
            err_reg <= 1'b0;

            case (state)
                S_FIVE: begin
                    if (in) begin
                        disc_reg <= 1'b1;
                    end
                end
                S_SIX: begin
                    if (in) begin
                        err_reg <= 1'b1;
                    end else begin
                        flag_reg <= 1'b1;
                    end
                end
                S_RESET, S_ZERO, S_ONE, S_TWO, S_THREE, S_FOUR: begin
                    if (state == S_SIX && in == 1'b0) begin
                        flag_reg <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Combinational logic
    always_comb begin
        case (state)
            S_RESET: begin
                if (in) begin
                    next_state = S_ONE;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_ZERO: begin
                if (in) begin
                    next_state = S_ONE;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_ONE: begin
                if (in) begin
                    next_state = S_TWO;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_TWO: begin
                if (in) begin
                    next_state = S_THREE;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_THREE: begin
                if (in) begin
                    next_state = S_FOUR;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_FOUR: begin
                if (in) begin
                    next_state = S_FIVE;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_FIVE: begin
                if (in) begin
                    next_state = S_SIX;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_SIX: begin
                if (in) begin
                    next_state = S_SIX;  // Stay in this state to keep asserting error
                end else begin
                    next_state = S_ZERO;
                end
            end
        endcase
    end

    // Assign output wires
    assign disc = disc_reg;
    assign flag = flag_reg;
    assign err = err_reg;

endmodule