module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state; // One-hot encoding for state A (1) and state B (0)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state A
        z <= 1'b0;
    end else begin
        if (state == 1'b1) begin
            if (x == 1'b1) begin
                state <= 1'b0;
                z <= 1'b1;
            end else begin
                state <= 1'b1;
                z <= 1'b0;
            end
        end else begin
            state <= 1'b0;
            z <= ~x;
        end
    end
end

endmodule