module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation using generate
    generate
        if (Q >= N) begin
            illegal_parameter_combination illegal_params();
        end
    endgenerate

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (N-1 bits)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Combined operation unit
    wire [N-1:0] a_full_mag = {1'b0, a_mag};
    wire [N-1:0] b_full_mag = {1'b0, b_mag};
    wire [N-1:0] mag_diff = (a_full_mag > b_full_mag) ? 
                          (a_full_mag - b_full_mag) : 
                          (b_full_mag - a_full_mag);

    // Shared adder/subtractor result
    wire [N:0] combined_result;
    wire do_add = (a_sign == b_sign);
    
    assign combined_result = do_add ? 
                           ({1'b0, a_mag} + {1'b0, b_mag}) : 
                           {1'b0, mag_diff};

    // Result selection and sign handling
    reg [N-1:0] res;
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign case
            res = {a_sign, combined_result[N-2:0]};
            // Overflow handling (check carry into sign bit)
            if (combined_result[N-1] && !combined_result[N]) begin
                res = {a_sign, {N-1{!a_sign}}}; // Saturate
            end
        end
        else begin
            // Different signs
            if (a_full_mag == b_full_mag) begin
                res = 0; // Zero result
            end
            else begin
                // Use sign of larger magnitude
                res = {(a_full_mag > b_full_mag) ? a_sign : b_sign, 
                       mag_diff[N-2:0]};
            end
        end
    end

    assign c = res;

endmodule