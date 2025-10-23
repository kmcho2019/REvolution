module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Validate parameters
    initial begin
        if (Q >= N) $error("Q must be less than N");
    end

    // Sign bits and operation type
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire op_add = (a_sign == b_sign);
    
    // Sign-extended operands
    wire [N:0] a_ext = {a_sign, a};
    wire [N:0] b_ext = {b_sign, b};
    
    // Arithmetic operation
    wire [N:0] sum = a_ext + b_ext;
    wire [N:0] diff = a_ext - b_ext;
    wire [N:0] arith_res = op_add ? sum : diff;
    
    // Sign determination
    wire res_sign;
    assign res_sign = op_add ? a_sign : 
                     (arith_res[N:0] == 0) ? 1'b0 : // Zero is positive
                     (arith_res[N]); // Otherwise use result's sign
    
    // Final result (truncate to N bits)
    assign c = {res_sign, arith_res[N-1:1]};

endmodule