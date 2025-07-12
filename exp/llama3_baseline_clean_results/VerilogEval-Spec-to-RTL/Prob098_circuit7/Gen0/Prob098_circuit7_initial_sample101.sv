module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1;

always @(posedge clk) begin
    if (a) begin
        q = ~q;
    end else begin
        q = 1;
    end
end

endmodule