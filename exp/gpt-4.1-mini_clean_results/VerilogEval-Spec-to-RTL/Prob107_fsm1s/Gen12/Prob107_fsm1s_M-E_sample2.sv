module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding:
    // B = 0, output = 1
    // A = 1, output = 0

    reg state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // B state
        else
            state <= (state == 1'b0) ? (~in) : in;
            // If in B and in=0, go to A (1)
            // If in B and in=1, stay in B (0)
            // If in A and in=0, go to B (0)
            // If in A and in=1, stay in A (1)
    end

    // Output logic: output is 1 when in B (state=0), else 0
    assign out = ~state;

endmodule