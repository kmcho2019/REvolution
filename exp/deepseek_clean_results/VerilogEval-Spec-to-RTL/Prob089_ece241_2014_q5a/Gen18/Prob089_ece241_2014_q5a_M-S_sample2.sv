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
            if (z == x) begin  // Haven't seen first '1' yet
                z <= x;
            end else begin     // After first '1', invert
                z <= ~x;
            end
        end
    end

endmodule