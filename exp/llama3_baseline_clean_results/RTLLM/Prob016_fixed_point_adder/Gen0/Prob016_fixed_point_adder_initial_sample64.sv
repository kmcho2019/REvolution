module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = (a[N-1])? -(~a + 1) + -(~b + 1) : a + b;
        res = (res >= (1 << N))? (1 << N) - 1 : res;
        res = (res < 0)? 0 : res;
    end else begin
        // Absolute value subtraction
        if ((a[N-1] == 0 && b[N-1] == 1 && -(~a + 1) > -(~b + 1)) ||
            (a[N-1] == 1 && b[N-1] == 0 && -(~a + 1) < -(~b + 1))) begin
            // a is larger
            res = -(~a + 1) - -(~b + 1);
        end else begin
            // b is larger
            res = -(~b + 1) - -(~a + 1);
        end
        res = (res >= (1 << N))? (1 << N) - 1 : res;
        res = (res < 0)? 0 : res;
    end
end

assign c = res;

endmodule