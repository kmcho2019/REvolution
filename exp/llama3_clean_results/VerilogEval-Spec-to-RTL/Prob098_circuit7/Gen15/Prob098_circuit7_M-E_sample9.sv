module TopModule(
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    if (a == prev_a) begin
        q <= ~q;
    end else begin
        prev_a <= a;
    end
end

initial begin
    prev_a = 1'b0; // Initialize prev_a to any value, as it will be updated on the first clock cycle
    q = 1'b1; // Initialize q to any value, as it will be updated based on the input
end

endmodule