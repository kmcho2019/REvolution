module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert_flag;  // 0 = copy, 1 = invert

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!invert_flag) begin
                z <= x;
                invert_flag <= x;  // Transition to invert on first '1'
            end else begin
                z <= ~x;  // Direct inversion for power efficiency
            end
        end
    end

endmodule