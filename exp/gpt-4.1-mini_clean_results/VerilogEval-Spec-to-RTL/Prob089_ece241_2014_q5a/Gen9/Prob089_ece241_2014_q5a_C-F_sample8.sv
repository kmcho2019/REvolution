module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 1'b0; // COPY state (waiting for first '1')
    localparam S1 = 1'b1; // INVERT state (after first '1')

    reg state, next_state;
    reg x_reg;
    reg output_bit;

    // Register input x and state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            x_reg <= x;
            state <= next_state;
            z <= x_reg ^ output_bit;
        end
    end

    // Next state logic: depends on registered x_reg and current state
    always @(*) begin
        case(state)
            S0: next_state = (x_reg) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Moore output bit depends only on current state
    always @(*) begin
        case(state)
            S0: output_bit = 1'b0; // pass bits as is
            S1: output_bit = 1'b1; // invert bits
            default: output_bit = 1'b0;
        endcase
    end

endmodule