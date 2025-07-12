module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Async reset to state B
        end else begin
            // Simplified transition logic for two states
            if (state) begin  // State B
                state <= in ? 1'b1 : 1'b0;
            end else begin    // State A
                state <= in ? 1'b0 : 1'b1;
            end
        end
    end

    // Output assignment (pure combinational)
    assign out = state;

endmodule