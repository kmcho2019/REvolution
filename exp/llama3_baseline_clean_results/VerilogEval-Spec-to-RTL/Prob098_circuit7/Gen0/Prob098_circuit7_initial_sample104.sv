module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (a == 1 && prev_a == 1) begin
        q <= 0;
    end else if (a == 0 && prev_a == 0) begin
        q <= 1;
    end
    prev_a <= a;
end

initial begin
    q = 1;
    prev_a = 0;
end

endmodule