module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;
    assign out = state;

    always @(posedge areset or posedge clk) begin
        if (areset) begin
            state <= 1'b1; // Reset to state B
        end else begin
            // Combinational logic to determine next state based on current state and input
            if (state && in) begin
                state <= state; // Stay in B if in B and input is 1
            end else if (!state && !in) begin
                state <= 1'b1; // Move to B if in A and input is 0
            end else if (state && !in) begin
                state <= 1'b0; // Move to A if in B and input is 0
            end else begin
                state <= state; // Stay in A if in A and input is 1
            end
        end
    end

endmodule