module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B (1)
        end else begin
            // Toggle state when (state^in) is true
            state <= state ^ (state == in);
        end
    end

    assign out = state;

endmodule