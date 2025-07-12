module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg should_invert;  // State: 0 = copy, 1 = invert bits

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            should_invert <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!should_invert) begin
                z <= x;
                should_invert <= x;  // Transition to invert state on first '1'
            end else begin
                z <= ~x;  // Invert all subsequent bits
            end
        end
    end

endmodule