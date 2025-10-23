module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

initial begin
    q = 1'b1;
    prev_a = 1'b0;
end

always @(posedge clk) begin
    if (prev_a && a) begin
        q <= 1'b0;
    end else if (!a) begin
        q <= 1'b1;
    end
    prev_a <= a;
end

endmodule