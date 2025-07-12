module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen;  // State: 0=COPY, 1=INVERT
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!seen) begin
                z <= x;
                seen <= x;  // Transition to INVERT when first '1' is seen
            end else begin
                z <= ~x;    // Stay in INVERT state and complement bits
            end
        end
    end

endmodule