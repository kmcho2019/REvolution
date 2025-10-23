module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Range check parameters
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (N-1 bits)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);

    // Operation selection
    wire do_add = (a_sign == b_sign);
    wire do_sub = ~do_add;

    // Magnitude results
    wire [N-1:0] add_res = {a_sign, a_mag + b_mag};
    wire [N-1:0] sub_res = a_gt_b ? {a_sign, a_mag - b_mag} 
                                  : {b_sign, b_mag - a_mag};

    // Final result
    assign c = do_add ? add_res : sub_res;

endmodule