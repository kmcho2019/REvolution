module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding: one-bit state
    localparam WAIT_FOR_FIRST_ONE = 1'b0;
    localparam INVERT_BITS        = 1'b1;

    reg state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            WAIT_FOR_FIRST_ONE: begin
                if (x == 1'b1)
                    next_state = INVERT_BITS;
                else
                    next_state = WAIT_FOR_FIRST_ONE;
            end
            INVERT_BITS: begin
                next_state = INVERT_BITS;
            end
            default: begin
                next_state = WAIT_FOR_FIRST_ONE;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_FIRST_ONE;
        else
            state <= next_state;
    end

    // Combinational output logic (Mealy output)
    assign z = (state == WAIT_FOR_FIRST_ONE) ? x : ~x;

endmodule