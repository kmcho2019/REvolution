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
            state <= state ? in : ~in;  // Efficient state transition logic
    end

    // Output assignment (Moore machine)
    assign out = (state == B);  // Explicit comparison for clarity

endmodule