module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (prev_a == 0 && a == 1) begin
        q <= 0;
    end else if (prev_a == 0 && a == 0) begin
        q <= 1;
    end
    prev_a <= a;
end

initial begin
    prev_a = 0;
    q = 1;
end

endmodule