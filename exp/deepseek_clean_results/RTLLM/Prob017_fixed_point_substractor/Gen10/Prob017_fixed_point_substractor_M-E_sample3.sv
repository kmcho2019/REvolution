module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign, b_sign;
    wire [N-2:0] a_mag, b_mag;
    wire signs_equal;
    wire [N-2:0] mag_diff, mag_sum;
    wire a_larger;

    // Extract signs and magnitudes
    assign a_sign = a[N-1];
    assign b_sign = b[N-1];
    assign a_mag = a[N-2:0];
    assign b_mag = b[N-2:0];
    
    // Sign comparison
    assign signs_equal = (a_sign == b_sign);
    
    // Magnitude operations
    assign mag_diff = (a_mag > b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    assign mag_sum = a_mag + b_mag;
    
    // Magnitude comparator
    assign a_larger = (a_mag > b_mag);
    
    // Result computation
    always @(*) begin
        if (signs_equal) begin
            // Same sign case
            c[N-1] = a_sign; // Result sign matches inputs
            c[N-2:0] = (a_mag > b_mag) ? mag_diff : mag_diff;
            
            // Handle zero result explicitly
            if (a == b) begin
                c = 0;
            end
        end
        else begin
            // Different sign case
            if (a_sign == 0) begin
                // a positive, b negative: a + |b|
                c[N-1] = 0;
                c[N-2:0] = mag_sum;
            end
            else begin
                // a negative, b positive: -(|a| + b)
                c[N-1] = 1;
                c[N-2:0] = mag_sum;
            end
            
            // Special case when magnitudes are equal
            if (a_mag == b_mag) begin
                c = 0;
            end
        end
    end

endmodule