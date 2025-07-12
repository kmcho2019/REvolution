module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!invert && x) begin
                invert <= 1'b1;
            end
            z <= x ^ invert;
        end
    end

endmodule