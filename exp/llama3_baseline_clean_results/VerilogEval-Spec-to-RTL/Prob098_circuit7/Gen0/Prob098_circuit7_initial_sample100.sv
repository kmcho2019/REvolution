module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (~a) begin
        q <= 1'b1;
    end else if (a) begin
        q <= ~q;
    end
end

endmodule