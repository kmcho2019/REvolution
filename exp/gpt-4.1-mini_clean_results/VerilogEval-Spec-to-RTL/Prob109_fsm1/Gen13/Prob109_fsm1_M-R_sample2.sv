module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;       // current state: 1 = B, 0 = A
    reg next_state;

    // Next state combinational logic with a case statement
    always @(*) begin
        case (state)
            1'b1: // state B
                next_state = (in == 1'b0) ? 1'b0 : 1'b1;
            1'b0: // state A
                next_state = (in == 1'b0) ? 1'b1 : 1'b0;
            default:
                next_state = 1'b1; // default to B on undefined state
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to state B
        else
            state <= next_state;
    end

    // Output is Moore machine output: directly the current state
    assign out = state;

endmodule