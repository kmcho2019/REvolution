module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            1'b0: next_state = j ? 1'b1 : 1'b0;  // OFF state transitions
            1'b1: next_state = k ? 1'b0 : 1'b1;  // ON state transitions
            default: next_state = 1'b0;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    assign out = state;

endmodule