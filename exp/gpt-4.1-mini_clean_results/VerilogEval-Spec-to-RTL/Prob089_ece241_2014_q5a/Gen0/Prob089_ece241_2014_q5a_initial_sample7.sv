module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    // STATE_BEFORE_FIRST_ONE = 0
    // STATE_AFTER_FIRST_ONE  = 1
    reg state;

    // Next state and output logic
    // Moore machine: output depends only on current state (and input x in combinational logic)
    // Actually output depends on state and input, but since it's Moore, we consider output as a function of state and input before clock.
    // The problem states "Moore state machine" but the output depends on input also.
    // For Moore output strictly, output depends only on state.
    // To make it strictly Moore, output depends on state only, so:
    // State 0 output: x
    // State 1 output: ~x
    // Output depends on input x but this is allowed in Moore if output is purely combinational from state and input at that moment.

    // We'll implement output as combinational from state and input.

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // reset to STATE_BEFORE_FIRST_ONE
            z <= 1'b0;     // output 0 on reset
        end else begin
            case (state)
                1'b0: begin
                    z <= x; // output input bit directly until first 1
                    if (x == 1'b1)
                        state <= 1'b1;
                    else
                        state <= 1'b0;
                end
                1'b1: begin
                    z <= ~x; // invert input bits after first 1
                    state <= 1'b1;
                end
            endcase
        end
    end

endmodule