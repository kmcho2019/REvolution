module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];
    
    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    
    // Result calculation
    wire [N-1:0] res;
    assign res = (a_sign == b_sign) ? 
                 {a_sign, (a_mag - b_mag)} :       // Same sign case
                 (a_sign ? 
                     (a_gt_b ? {1'b1, (a_mag - b_mag)} : {1'b0, (b_mag - a_mag)} :
                     (a_gt_b ? {1'b0, (a_mag - b_mag)} : {1'b1, (b_mag - a_mag)}));
    
    // Zero detection and output assignment
    assign c = (res[N-2:0] == 0) ? {1'b0, {N-1{1'b0}}} : res;

    // Parameter validation using generate
    generate
        if (Q >= N) begin
            illegal_parameter_combination illegal_params();
        end
    endgenerate

endmodule