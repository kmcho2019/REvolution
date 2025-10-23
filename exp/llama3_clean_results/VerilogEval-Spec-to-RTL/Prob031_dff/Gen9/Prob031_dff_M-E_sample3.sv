module TopModule(
    input clk,
    input d,
    output reg q
);

reg enable;

always @(posedge clk) begin
    enable <= 1'b1;
end

always @(negedge clk) begin
    enable <= 1'b0;
end

always @(d or enable) begin
    if (enable) begin
        q <= d;
    end
end

endmodule