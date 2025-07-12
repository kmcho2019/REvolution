module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: COPY, 1: INVERT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            z <= 0;
        end else begin
            z <= x ^ state; // XNOR when state=1 (invert), XOR when state=0 (copy)
            if (x & ~state) state <= 1; // Transition to INVERT state on first '1'
        end
    end

endmodule