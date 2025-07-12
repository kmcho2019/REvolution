module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding: 1 bit
    localparam BEFORE_ONE = 1'b0;
    localparam AFTER_ONE  = 1'b1;

    reg state, next_state;

    // Next state logic: asynchronous reset handled in sequential always
    always @(*) begin
        case(state)
            BEFORE_ONE: 
                next_state = (x == 1'b1) ? AFTER_ONE : BEFORE_ONE;
            AFTER_ONE: 
                next_state = AFTER_ONE;
            default: 
                next_state = BEFORE_ONE;
        endcase
    end

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_ONE;
        else
            state <= next_state;
    end

    // Output logic (Mealy): depends on state and current input x
    assign z = (state == BEFORE_ONE) ? x : ~x;

endmodule