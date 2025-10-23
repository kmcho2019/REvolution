module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding: 0 = COPY (pass bits until first '1'), 1 = INVERT (invert bits after first '1')
    reg state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // COPY state on reset
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            1'b0: // COPY state
                if (x)
                    next_state = 1'b1; // transition to INVERT on first '1'
                else
                    next_state = 1'b0;
            1'b1: // INVERT state
                next_state = 1'b1; // stay in INVERT
            default:
                next_state = 1'b0;
        endcase
    end

    // Moore output: invert x when in INVERT state
    assign z = x ^ state;

endmodule