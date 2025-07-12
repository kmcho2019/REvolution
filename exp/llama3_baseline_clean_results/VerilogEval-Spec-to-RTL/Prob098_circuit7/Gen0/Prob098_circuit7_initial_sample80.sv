module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a == 0) begin
        q <= 1;
    end else if (a == 1) begin
        q <= 0;
    end
end

endmodule