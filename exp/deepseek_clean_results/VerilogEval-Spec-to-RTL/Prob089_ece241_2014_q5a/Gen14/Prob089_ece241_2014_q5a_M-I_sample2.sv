module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen; // State: tracks if we've seen the first '1'
    wire clk_en = ~areset; // Clock gating for power reduction
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen <= 1'b0;
            z <= 1'b0;
        end else if (clk_en) begin
            seen <= seen | x; // Set seen when first '1' encountered
            z <= seen ? ~x : x; // Invert if we've seen a '1'
        end
    end

endmodule