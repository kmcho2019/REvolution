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
            if (!z) begin
                z <= x;
            end else begin
                z <= ~x;
            end
        end
    end

endmodule