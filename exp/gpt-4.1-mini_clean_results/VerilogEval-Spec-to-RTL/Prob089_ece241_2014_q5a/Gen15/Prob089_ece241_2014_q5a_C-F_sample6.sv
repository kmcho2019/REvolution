module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding: S0 = copy bits until first '1' (carry start), S1 = invert bits after first '1'
    typedef enum logic {S0 = 1'b0, S1 = 1'b1} state_t;

    state_t state;

    reg x_reg;

    // Input sampling register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else begin
            case(state)
                S0: state <= (x_reg) ? S1 : S0;
                S1: state <= S1;
                default: state <= S0;
            endcase
        end
    end

    // Output combinational logic, Moore FSM output depends only on current state and registered input
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule