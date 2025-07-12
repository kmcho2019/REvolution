module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    always @(*) begin
        res = a - b;
        // If result is zero, ensure sign bit is zero (avoid negative zero)
        if (res == 0)
            res[N-1] = 1'b0;
        c = res;
    end

endmodule