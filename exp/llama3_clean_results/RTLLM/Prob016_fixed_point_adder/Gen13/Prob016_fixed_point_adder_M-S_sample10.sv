module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  clk,
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

wire sign_a = a[N-1];
wire sign_b = b[N-1];

always @(posedge clk) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        res <= a + b;
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            res <= a - b;
        end else begin
            res <= b - a;
        end
    end
end

assign c = res;

endmodule