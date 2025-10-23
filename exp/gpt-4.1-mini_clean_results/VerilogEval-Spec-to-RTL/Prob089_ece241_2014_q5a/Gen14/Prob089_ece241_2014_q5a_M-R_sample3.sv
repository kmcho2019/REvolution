module TopModule (
    input  clk,
    input  areset,
    input  x,
    output wire z
);

    localparam S0 = 1'b0; // waiting for first '1'
    localparam S1 = 1'b1; // inverting subsequent bits

    reg state, next_state;
    reg x_reg, x_reg_next;

    // Input sampling
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

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (x_reg) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Moore output logic (combinational)
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule