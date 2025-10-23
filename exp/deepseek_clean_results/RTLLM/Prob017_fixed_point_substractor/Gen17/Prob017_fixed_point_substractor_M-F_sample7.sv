module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total bit width
) (
    input wire signed [N-1:0] a,  // First fixed-point operand
    input wire signed [N-1:0] b,  // Second fixed-point operand
    output wire signed [N-1:0] c   // Subtraction result
);

    wire signed [N-1:0] magnitude;
    wire result_sign;

    // Calculate magnitude based on sign cases
    assign magnitude = (a[N-1] == b[N-1]) ? 
                      (a - b) :           // Same sign: simple subtraction
                      (a + b);             // Different signs: add magnitudes

    // Determine result sign
    assign result_sign = (a[N-1] == b[N-1]) ? 
                        a[N-1] :            // Same sign: keep input sign
                        (a[N-1] ?           // Different signs:
                            (a[N-1:0] > {1'b0, ~b[N-2:0] + 1'b1}) :  // a negative, b positive
                            (a[N-1:0] > b[N-1:0]));                   // a positive, b negative

    // Handle zero case and final result
    assign c = (magnitude == 0) ? {1'b0, {(N-1){1'b0}}} : 
               {result_sign, magnitude[N-2:0]};

endmodule