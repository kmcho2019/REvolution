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
            state <= in;    // Next state is simply the input
        end
    end

    assign out = state;     // Moore output

endmodule