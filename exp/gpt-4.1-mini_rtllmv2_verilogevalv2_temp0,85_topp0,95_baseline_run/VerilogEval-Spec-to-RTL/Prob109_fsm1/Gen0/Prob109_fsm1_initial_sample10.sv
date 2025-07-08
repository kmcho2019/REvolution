module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: // state = 1
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            A: // state = 0
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            default:
                next_state = B; // default to B on undefined state
        endcase
    end

    // Output logic (Moore output depends only on state)
    always @(*) begin
        out = state;
    end

endmodule