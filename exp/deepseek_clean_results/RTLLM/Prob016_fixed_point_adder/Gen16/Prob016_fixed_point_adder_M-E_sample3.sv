module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign prediction logic
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);
    
    // Early sign prediction for result
    wire res_sign_pred = signs_equal ? a_sign : 
                       (a[N-2:0] > b[N-2:0]) ? a_sign : b_sign;

    // Magnitude extraction with sign extension
    wire [N-1:0] a_mag = {1'b0, a[N-2:0]};
    wire [N-1:0] b_mag = {1'b0, b[N-2:0]};

    // Carry-select arithmetic unit
    wire [N-1:0] sum, diff;
    
    // Upper bits computation (carry-select)
    wire [N/2-1:0] sum_low = a_mag[N/2-1:0] + b_mag[N/2-1:0];
    wire [N/2-1:0] sum_high_c0 = a_mag[N-1:N/2] + b_mag[N-1:N/2];
    wire [N/2-1:0] sum_high_c1 = a_mag[N-1:N/2] + b_mag[N-1:N/2] + 1;
    assign sum = {sum_high_c0, sum_low};  // Default no carry
    
    // Unified subtractor (always subtract smaller from larger)
    wire [N-1:0] max_mag = (a_mag > b_mag) ? a_mag : b_mag;
    wire [N-1:0] min_mag = (a_mag > b_mag) ? b_mag : a_mag;
    assign diff = max_mag - min_mag;

    // Overflow detection
    wire overflow = signs_equal & (sum[N-1] | sum[N-2]);

    // Result selection and saturation
    always @(*) begin
        if (overflow) begin
            c = {res_sign_pred, {N-1{~res_sign_pred}}};  // Saturate
        end
        else begin
            c = {res_sign_pred, signs_equal ? sum[N-2:0] : diff[N-2:0]};
        end
    end

endmodule