module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Validate parameters
    initial begin
        if (Q >= N) $error("Q must be less than N");
    end

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (N-1 bits)
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Full-width magnitudes for comparison
    wire [N-1:0] a_full_mag = {1'b0, a_mag};
    wire [N-1:0] b_full_mag = {1'b0, b_mag};

    // Addition/subtraction results
    wire [N:0] add_result = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N:0] sub_result = (a_full_mag > b_full_mag) ? 
                           {1'b0, a_full_mag - b_full_mag} : 
                           {1'b0, b_full_mag - a_full_mag};

    // Result selection logic
    reg [N-1:0] res;
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign - add magnitudes
            res = {a_sign, add_result[N-2:0]};
            
            // Overflow detection
            if (add_result[N-1] && !add_result[N]) begin
                res = {a_sign, {N-1{!a_sign}}}; // Saturate
            end
        end
        else begin
            // Different signs - subtract smaller from larger
            if (a_full_mag == b_full_mag) begin
                res = 0; // Special case: equal magnitudes
            end
            else if (a_full_mag > b_full_mag) begin
                res = {a_sign, sub_result[N-2:0]};
            end
            else begin
                res = {b_sign, sub_result[N-2:0]};
            end
        end
    end

    assign c = res;

endmodule