module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg flag; // Flag to indicate whether we are in the complement phase

always @(posedge clk or posedge areset) begin
    if (areset) begin
        flag <= 1'b0;
        z <= 1'b0;
    end else begin
        if (~flag) begin
            if (x) begin
                flag <= 1'b1;
            end
            z <= x;
        end else begin
            z <= ~x;
        end
    end
end

endmodule