module TopModule (
    input  clk,
    input  areset,
    input  x,
    output wire z
);

    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;
    reg x_reg;
    reg next_state;

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
        else
            state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        case(state)
            S0: next_state = (x_reg == 1'b1) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Moore output combinational logic based on registered state and input
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule