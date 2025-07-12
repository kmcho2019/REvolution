module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a == 1) begin
        q <= 0;
    end else begin
        q <= 1;
    end
end

initial begin
    q = 1;
end

endmodule