module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen; // Tracks if we've seen the first '1'
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!seen) begin
                z <= x;
                seen <= x; // Transition to invert state after first '1'
            end else begin
                z <= x ^ 1'b1; // Efficient inversion using XOR
            end
        end
    end

endmodule