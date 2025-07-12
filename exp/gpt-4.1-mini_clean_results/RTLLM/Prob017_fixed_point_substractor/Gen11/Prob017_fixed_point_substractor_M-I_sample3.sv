module fixed_point_subtractor #(
    parameter Q = 8,          // Number of fractional bits
    parameter N = 16          // Total number of bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    // Internal register to hold the subtraction result
    reg signed [N-1:0] res;

    always @(*) begin
        // Perform fixed-point subtraction using signed arithmetic
        res = a - b;

        // If result is zero, clear sign bit explicitly
        if (res == 0) begin
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            c = res;
        end
    end

endmodule