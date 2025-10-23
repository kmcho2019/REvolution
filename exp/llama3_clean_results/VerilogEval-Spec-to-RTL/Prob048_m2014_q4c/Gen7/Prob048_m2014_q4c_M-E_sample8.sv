module TopModule(
    input clk,
    input d,
    input r,
    output reg q = 1'b0
);

always @(posedge clk or posedge r) begin
    if (r) begin
        q <= 1'b0;
    end
end

always @(posedge clk) begin
    if (!r) begin
        q <= d;
    end
end

endmodule