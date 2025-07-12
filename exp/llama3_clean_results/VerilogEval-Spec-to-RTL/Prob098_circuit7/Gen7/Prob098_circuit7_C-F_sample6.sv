module TopModule(
    input clk,
    input a,
    output reg q = 1'b1
);

always @(posedge clk) begin
    if (a) begin
        q <= ~a;
    end else begin
        q <= ~a;
    end
end

endmodule