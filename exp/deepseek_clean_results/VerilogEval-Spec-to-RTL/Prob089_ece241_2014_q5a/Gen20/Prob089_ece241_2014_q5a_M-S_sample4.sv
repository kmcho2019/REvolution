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
            if (z == 1'b0) begin
                z <= x;  // Copy input until first '1'
            end else begin
                z <= ~x;  // Invert after first '1'
            end
        end
    end

endmodule