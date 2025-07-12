module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
            z <= 1'b0;
        end
        else begin
            if (!seen_one) begin
                z <= x;
                seen_one <= x;
            end
            else begin
                z <= ~x;
            end
        end
    end

endmodule