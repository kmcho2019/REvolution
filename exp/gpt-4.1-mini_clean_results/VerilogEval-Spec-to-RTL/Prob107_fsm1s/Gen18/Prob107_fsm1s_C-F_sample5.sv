module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg state;        // current state: 0 = B, 1 = A
    reg next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            1'b0: next_state = in ? 1'b0 : 1'b1; // B state
            1'b1: next_state = in ? 1'b1 : 1'b0; // A state
            default: next_state = 1'b0;           // Default to B
        endcase
    end

    // State register update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // reset to B state
        else
            state <= next_state;
    end

    // Output logic (Moore output depends only on state)
    assign out = ~state;

endmodule