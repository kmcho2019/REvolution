module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;
always @(posedge clk) begin
    prev_a <= a;
    if (prev_a == 1'b0 || (a == 1'b0 && q == 1'b0)) begin
        q <= 1'b1;
    end else if (a == 1'b1 && q == 1'b1) begin
        q <= 1'b0;
    end
end

endmodule