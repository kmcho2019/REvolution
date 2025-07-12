`timescale 1ns / 1ps

module fixed_point_subtractor #(
    parameter integer N = 16,  // Total bits (including sign bit)
    parameter integer Q = 8    // Fractional bits count
)(
    input  wire signed [N-1:0] a,   // Input a in two's complement fixed-point
    input  wire signed [N-1:0] b,   // Input b in two's complement fixed-point
    output wire signed [N-1:0] c    // Output c = a - b in two's complement fixed-point
);

    // Function to convert two's complement to magnitude (N-1 bits)
    function [N-2:0] twos_comp_to_mag;
        input signed [N-1:0] val;
        reg [N-2:0] mag;
        begin
            if (val[N-1] == 1'b0)
                mag = val[N-2:0];
            else
                mag = (~val[N-2:0]) + 1'b1;
            twos_comp_to_mag = mag;
        end
    endfunction

    // Function to convert sign and magnitude to two's complement
    function signed [N-1:0] sign_mag_to_twos;
        input sign;
        input [N-2:0] mag;
        reg [N-1:0] val;
        begin
            if (sign == 1'b0)
                val = {1'b0, mag};
            else
                val = {1'b1, (~mag + 1'b1)};
            sign_mag_to_twos = val;
        end
    endfunction

    // Extract input signs
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Convert inputs to magnitude
    wire [N-2:0] a_mag = twos_comp_to_mag(a);
    wire [N-2:0] b_mag = twos_comp_to_mag(b);

    // Determine if same sign
    wire same_sign = (a_sign == b_sign);

    // Calculate preliminary result sign and magnitude
    wire res_sign_sub;     // for subtraction when same sign
    wire [N-2:0] res_mag_sub;
    wire res_sign_add;     // for addition when different sign
    wire [N-2:0] res_mag_add;

    // Subtraction when same sign: res_mag = |a_mag - b_mag|, res_sign based on which is larger
    assign res_mag_sub = (a_mag >= b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    assign res_sign_sub = (a_mag >= b_mag) ? a_sign : ~a_sign;

    // Addition when different sign: res_mag = a_mag + b_mag
    assign res_mag_add = a_mag + b_mag;
    // res_sign is sign of larger magnitude input; if equal magnitude, zero
    wire equal_mag = (a_mag == b_mag);
    wire larger_a = (a_mag > b_mag);
    wire larger_b = (b_mag > a_mag);
    assign res_sign_add = equal_mag ? 1'b0 : (larger_a ? a_sign : b_sign);

    // Select result magnitude and sign based on input signs
    wire [N-2:0] res_mag_pre = same_sign ? res_mag_sub : res_mag_add;
    wire res_sign_pre = same_sign ? res_sign_sub : res_sign_add;

    // Zero magnitude correction: if magnitude zero, force sign = 0
    wire res_zero = (res_mag_pre == { (N-1){1'b0} });
    wire res_sign_final = res_zero ? 1'b0 : res_sign_pre;
    wire [N-2:0] res_mag_final = res_mag_pre;

    // Internal register res updated combinationally
    reg signed [N-1:0] res;
    always @(*) begin
        res = sign_mag_to_twos(res_sign_final, res_mag_final);
    end

    // Output assignment
    assign c = res;

endmodule