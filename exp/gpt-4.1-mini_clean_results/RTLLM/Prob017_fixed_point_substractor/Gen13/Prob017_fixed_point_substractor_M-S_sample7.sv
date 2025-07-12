`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits including sign
    parameter integer Q = 8    // Fractional bits
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    reg signed [N-1:0] res;

    always @(*) begin
        res = a - b;
        // Explicitly clear sign bit if result is zero
        if (res == 0)
            res[N-1] = 1'b0;
    end

    always @(*) begin
        c = res;
    end

endmodule