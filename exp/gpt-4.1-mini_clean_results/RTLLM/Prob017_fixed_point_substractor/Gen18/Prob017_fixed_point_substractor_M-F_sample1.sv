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
        // Perform fixed-point subtraction using signed arithmetic
        res = a - b;

        // If result is zero, explicitly clear sign bit (MSB)
        if (res == 0)
            res = {1'b0, {(N-1){1'b0}}};
    end

    always @* begin
        c = res;
    end

endmodule