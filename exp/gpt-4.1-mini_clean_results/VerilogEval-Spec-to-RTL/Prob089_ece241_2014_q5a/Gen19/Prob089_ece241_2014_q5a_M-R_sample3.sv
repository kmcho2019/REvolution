module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state;
    reg x_reg;

    // Synchronous logic with asynchronous reset: update state and sample input
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
            x_reg <= 1'b0;
        end else begin
            state <= (state == BEFORE_CARRY && x_reg == 1'b1) ? AFTER_CARRY : state;
            x_reg <= x;
        end
    end

    // Next state combinational logic using assign
    // This is implicit in the always block update above, so no separate reg needed

    // Output logic (Moore FSM output): depends on current state and sampled input
    assign z = (state == BEFORE_CARRY) ? x_reg :
               (state == AFTER_CARRY)  ? ~x_reg :
               1'b0;

endmodule