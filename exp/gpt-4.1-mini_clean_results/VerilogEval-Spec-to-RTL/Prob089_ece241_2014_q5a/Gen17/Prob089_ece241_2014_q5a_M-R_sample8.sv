module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 1'b0; // Copy bits until first '1' detected
    localparam S1 = 1'b1; // Invert bits after first '1'

    reg state, next_state;
    reg x_reg;

    // Input sampling register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // Next-state combinational logic
    always @(*) begin
        case(state)
            S0: next_state = (x_reg) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output register (Moore FSM output), asynchronous reset to 0
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else begin
            case(state)
                S0: z <= x_reg;
                S1: z <= ~x_reg;
                default: z <= 1'b0;
            endcase
        end
    end

endmodule