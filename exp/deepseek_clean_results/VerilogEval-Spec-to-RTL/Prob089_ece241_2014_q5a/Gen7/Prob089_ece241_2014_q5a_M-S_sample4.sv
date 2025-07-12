module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_first_1;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_first_1 <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!seen_first_1) begin
                z <= x;
                if (x) seen_first_1 <= 1'b1;
            end else begin
                z <= ~x;
            end
        end
    end

endmodule