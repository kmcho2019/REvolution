module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (~a !== q) begin
        q <= ~a;
    end
end

endmodule