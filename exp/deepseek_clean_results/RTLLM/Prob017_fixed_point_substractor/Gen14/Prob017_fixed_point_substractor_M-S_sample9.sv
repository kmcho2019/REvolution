module fixed_point_subtractor #(
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,    // First operand
    input wire [N-1:0] b,    // Second operand
    output wire [N-1:0] c    // Subtraction result
);

    // Direct signed subtraction with zero sign handling
    assign c = ($signed(a) - $signed(b)) == 0 ? 
               {1'b0, {N-1{1'b0}}} : 
               $signed(a) - $signed(b);

endmodule