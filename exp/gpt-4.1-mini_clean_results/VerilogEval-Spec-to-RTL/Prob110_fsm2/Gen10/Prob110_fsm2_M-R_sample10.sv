module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding: state=0 means OFF, state=1 means ON
    reg state;
    wire next_state;

    // Next state logic using assign and ternary operators
    assign next_state = (state == 1'b0) ? (j ? 1'b1 : 1'b0)  // OFF: j=1 -> ON, else OFF
                                    : (k ? 1'b0 : 1'b1);     // ON:  k=1 -> OFF, else ON

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // OFF state
        else
            state <= next_state;
    end

    // Output directly driven by state (Moore output)
    assign out = state;

endmodule