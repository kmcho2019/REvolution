module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    reg state;          // Current state: 1 = B, 0 = A
    reg next_state;     // Next state

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to B
        else
            state <= next_state;
    end

    // Combinational logic to determine next state
    always @(*) begin
        case (state)
            1'b1: // State B
                next_state = (in == 1'b0) ? 1'b0 : 1'b1;
            1'b0: // State A
                next_state = (in == 1'b0) ? 1'b1 : 1'b0;
            default:
                next_state = 1'b1; // Safety fallback to B
        endcase
    end

    // Moore output depends only on current state
    assign out = state;

endmodule