module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // B=1, A=0

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            state <= state ^ ~in;  // Simplified transition logic
        end
    end

    assign out = state;  // Direct output

endmodule