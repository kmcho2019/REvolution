module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            // Use z itself as the state indicator
            if (z) begin
                z <= ~x;  // Invert bits after first '1'
            end else begin
                z <= x;   // Pass through until first '1'
            end
        end
    end

endmodule