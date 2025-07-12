module fixed_point_adder #(
    parameter integer Q = 8,          // Number of fractional bits (precision)
    parameter integer N = 16          // Total bits including sign and fractional bits
)(
    input  wire signed [N-1:0] a,    // First fixed-point operand (signed two's complement)
    input  wire signed [N-1:0] b,    // Second fixed-point operand (signed two's complement)
    output reg  signed [N-1:0] c     // Fixed-point addition result (signed two's complement)
);

    // Internal register to hold result as required
    reg signed [N-1:0] res;

    always @(*) begin
        // Perform fixed-point addition directly on signed inputs
        res = a + b;
    end

    // Assign output from internal register
    always @(*) begin
        c = res;
    end

endmodule

/*
Notes:

- Inputs and outputs are signed fixed-point numbers in two's complement form.
- Parameter Q defines fractional bits; parameter N is total bits (including sign).
- Addition uses signed arithmetic directly; no explicit sign or absolute value manipulation needed.
- Internal register 'res' stores the result combinationally, matching the problem's instruction.
- Overflow behaves as two's complement wrap-around (no saturation).
- This module is combinational (no clock), output 'c' follows inputs immediately.
- When instantiating, be sure to pass parameters explicitly if defaults need overriding, e.g.:

    fixed_point_adder #(.Q(8), .N(16)) adder_inst (
        .a(input_a),
        .b(input_b),
        .c(output_c)
    );

- Ensure the testbench uses the exact module name 'fixed_point_adder' and passes parameters as above.
*/