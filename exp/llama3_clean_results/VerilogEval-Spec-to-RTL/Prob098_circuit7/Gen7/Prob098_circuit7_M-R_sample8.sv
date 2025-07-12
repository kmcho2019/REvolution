module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1'b1;

always @(posedge clk) begin
    if (~a) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
end

endmodule