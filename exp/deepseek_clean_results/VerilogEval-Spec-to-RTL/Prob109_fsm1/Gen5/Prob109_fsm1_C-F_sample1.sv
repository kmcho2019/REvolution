module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states with parameters for readability
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Optimized state transition using XOR logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Async reset to state B
        end else begin
            state <= state ^ ~in;  // Equivalent to (state ? in : ~in)
        end
    end

    // Output is directly the state (Moore machine)
    assign out = state;

endmodule