module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a == 1'b0 && a == 1'b0) begin
        q <= 1'b1;
    end else if (prev_a == 1'b1 && a == 1'b1) begin
        q <= 1'b0;
    end else if (prev_a == 1'b1 && a == 1'b0) begin
        q <= 1'b1;
    end
end

endmodule