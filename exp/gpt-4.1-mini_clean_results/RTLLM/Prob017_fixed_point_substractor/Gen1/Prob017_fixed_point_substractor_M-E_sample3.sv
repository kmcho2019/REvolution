module fixed_point_subtractor #
(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total number of bits (including sign)
)
(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg signed [N-1:0] a_s;
    reg signed [N-1:0] b_s;
    reg signed [N-1:0] res;

    always @(*) begin
        // Cast inputs to signed values (two's complement)
        a_s = $signed(a);
        b_s = $signed(b);

        // Perform subtraction directly (a - b)
        res = a_s - b_s;

        // If result is zero, explicitly clear sign bit to zero
        if (res == 0) begin
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            c = res;
        end
    end

endmodule