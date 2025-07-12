module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state, next_state;

    // Next state logic as simple combinational assignments
    always @(*) begin
        if (state == 1'b0) // OFF state
            next_state = j ? 1'b1 : 1'b0; // ON if j=1, else OFF
        else               // ON state
            next_state = k ? 1'b0 : 1'b1; // OFF if k=1, else ON
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF state
        else
            state <= next_state;
    end

    // Output depends only on state (Moore machine)
    assign out = state;

endmodule