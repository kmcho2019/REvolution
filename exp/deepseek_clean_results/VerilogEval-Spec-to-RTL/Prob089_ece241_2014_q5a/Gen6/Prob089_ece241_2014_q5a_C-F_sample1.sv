module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: COPY, 1: INVERT

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            // State transition logic (optimized)
            state <= state | x;
            
            // Output logic (state-based)
            if (state) begin
                z <= ~x; // INVERT state
            end else begin
                z <= x;  // COPY state
            end
        end
    end

endmodule