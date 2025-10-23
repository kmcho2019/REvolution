module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!seen) begin
                z <= x;
                seen <= x;
            end else begin
                z <= ~x;
            end
        end
    end

endmodule