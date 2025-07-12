module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    typedef enum logic { S0, S1 } state_t;
    state_t state, next_state;

    reg x_reg;

    // Sequential logic: sample input and update state and output on clk or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            x_reg <= x;

            // State transitions
            case (state)
                S0: next_state = (x_reg) ? S1 : S0;
                S1: next_state = S1;
                default: next_state = S0;
            endcase
            state <= next_state;

            // Moore output logic depends only on current state and registered input
            case (state)
                S0: z <= x_reg;
                S1: z <= ~x_reg;
                default: z <= 1'b0;
            endcase
        end
    end

endmodule