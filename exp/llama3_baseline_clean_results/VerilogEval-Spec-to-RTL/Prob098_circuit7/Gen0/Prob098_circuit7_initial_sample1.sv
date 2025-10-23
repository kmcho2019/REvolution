module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (a && prev_a) begin
        q <= 1'b0;
    end else begin
        q <= 1'b1;
    end
end

endmodule