module fixed_point_subtractor #(
    parameter N = 32,  // Total number of bits
    parameter Q = 16   // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];

    // Magnitude comparison
    wire a_larger = (a_mag > b_mag);
    wire magnitudes_equal = (a_mag == b_mag);

    // Magnitude subtraction
    wire [N-2:0] mag_diff = a_larger ? (a_mag - b_mag) : (b_mag - a_mag);

    // Sign determination logic
    reg result_sign;
    always @(*) begin
        if (magnitudes_equal) begin
            result_sign = 1'b0;  // Zero result
        end
        else if (a_sign == b_sign) begin
            result_sign = a_sign; // Same signs
        end
        else begin
            result_sign = a_sign ? ~a_larger : a_larger;
        end
    end

    // Final result assembly
    wire [N-1:0] result = {result_sign, mag_diff};

    // Zero detection and output
    assign c = magnitudes_equal ? {1'b0, {N-1{1'b0}}} : result;

endmodule