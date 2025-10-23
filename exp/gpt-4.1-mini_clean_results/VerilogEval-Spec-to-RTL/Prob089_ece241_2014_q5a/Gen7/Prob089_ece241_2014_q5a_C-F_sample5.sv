module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // Enumerated state type
    typedef enum logic {COPY = 1'b0, INVERT = 1'b1} state_t;

    state_t state, next_state;
    logic inversion_bit, next_inversion_bit;
    logic x_reg;

    // Register input x to synchronize and avoid glitches
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State and inversion_bit registers with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            inversion_bit <= 1'b0;
        end else begin
            state <= next_state;
            inversion_bit <= next_inversion_bit;
        end
    end

    // Next state and inversion bit logic
    always_comb begin
        case(state)
            COPY: begin
                if (x_reg == 1'b1) begin
                    next_state = INVERT;
                    next_inversion_bit = 1'b1;
                end else begin
                    next_state = COPY;
                    next_inversion_bit = 1'b0;
                end
            end
            INVERT: begin
                next_state = INVERT;
                next_inversion_bit = 1'b1;
            end
            default: begin
                next_state = COPY;
                next_inversion_bit = 1'b0;
            end
        endcase
    end

    // Output combinational logic: Moore FSM output depends only on current state (inversion_bit) and registered input x_reg
    assign z = x_reg ^ inversion_bit;

endmodule