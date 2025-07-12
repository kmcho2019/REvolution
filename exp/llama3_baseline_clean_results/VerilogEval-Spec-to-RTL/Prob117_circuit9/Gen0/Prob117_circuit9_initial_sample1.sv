module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 0;

always @(posedge clk) begin
    if (a == 1 && q == 0) begin
        q <= 4;
    end else if (a == 0) begin
        q <= (q == 7) ? 0 : q + 1;
    end
end

endmodule