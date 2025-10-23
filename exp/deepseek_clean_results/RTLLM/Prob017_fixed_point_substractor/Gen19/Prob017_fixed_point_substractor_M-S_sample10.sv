module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform subtraction directly
    wire [N-1:0] sub_result = a - b;
    
    // Detect zero result (all bits zero)
    wire is_zero = (sub_result == {N{1'b0}});
    
    // Output handling - explicit zero sign bit
    assign c = is_zero ? {N{1'b0}} : sub_result;

endmodule