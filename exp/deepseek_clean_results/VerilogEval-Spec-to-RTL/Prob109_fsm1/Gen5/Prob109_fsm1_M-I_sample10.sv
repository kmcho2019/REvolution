module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0 for A, 1 for B (matches output directly)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state = 1'b1;  // Async reset to state B
        end else begin
            // Simplified state transition logic
            state = (state) ? in : ~in;
        end
    end

    assign out = state;  // Direct state assignment

endmodule