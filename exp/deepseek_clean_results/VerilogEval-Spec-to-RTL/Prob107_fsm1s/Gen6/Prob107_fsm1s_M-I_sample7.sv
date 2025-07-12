module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    reg state;
    localparam B = 1'b0;
    localparam A = 1'b1;

    // State transitions
    always @(posedge clk) begin
        if (reset)
            state <= B;  // Synchronous reset to state B
        else
            state <= state ? in : ~in;  // Optimal state transition logic
    end

    // Optimized output assignment
    assign out = ~state;  // Direct bitwise NOT for minimal logic

endmodule