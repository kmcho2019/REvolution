`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,
    parameter integer Q = 8
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output reg  signed [N-1:0] c
);

    reg signed [N-1:0] res;

    always @* begin
        res = a - b;
        // Handle zero result with explicit zero sign bit
        if (res == 0) begin
            // force sign bit to 0, rest zero
            res = {1'b0, {(N-1){1'b0}}};
        end
        c = res;
    end

endmodule