module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign, perform addition
        res = a + b;
    end else begin // Different signs, perform subtraction
        res = (a[N-1] == 1'b0) ? a - b : b - a; // Determine which to subtract from
    end
    // Overflow handling: saturate at maximum value
    if (res >= (1 << N)) begin 
        res = (1 << N) - 1; 
    end
    c = res;
end

endmodule