module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert;  // State: 0 = pass through, 1 = invert bits

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!invert) begin
                z <= x;
                invert <= x;  // Transition to invert state on first '1'
            end else begin
                z <= ~x;  // Invert all subsequent bits
            end
        end
    end

endmodule