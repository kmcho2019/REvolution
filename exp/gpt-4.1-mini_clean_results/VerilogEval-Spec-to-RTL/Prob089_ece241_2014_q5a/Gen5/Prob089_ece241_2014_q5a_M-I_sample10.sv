module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // Single state bit: 0 = before first '1', 1 = after first '1'
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            // State update
            if (!state && x)
                state <= 1'b1;

            // Output logic (Moore output depends only on state and input)
            // Before first '1': output = x
            // After first '1': output = ~x
            z <= state ? ~x : x;
        end
    end

endmodule