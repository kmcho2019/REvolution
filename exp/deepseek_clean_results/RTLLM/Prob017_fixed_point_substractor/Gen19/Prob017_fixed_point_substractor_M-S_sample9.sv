module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Perform the subtraction directly
    wire [N-1:0] sub_result = a - b;
    
    // Detect zero result (all bits zero)
    wire is_zero = ~(|sub_result);
    
    // Output: force zero to positive, otherwise pass through result
    assign c = is_zero ? {1'b0, {(N-1){1'b0}}} : sub_result;

endmodule