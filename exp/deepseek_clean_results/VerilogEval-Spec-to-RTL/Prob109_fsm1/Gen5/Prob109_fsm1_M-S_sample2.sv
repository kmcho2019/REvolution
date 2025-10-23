module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Async reset to state B
        end else begin
            state <= state ? state : in;  // Stay in B if in B, else go to in
        end
    end

    assign out = state;

endmodule