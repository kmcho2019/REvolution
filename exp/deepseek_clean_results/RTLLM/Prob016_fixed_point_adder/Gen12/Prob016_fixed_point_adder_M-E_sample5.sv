module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Convert to sign-magnitude format
    wire a_sign = a[N-1];
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    
    wire b_sign = b[N-1];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Determine operation type and magnitude order
    wire signs_equal = (a_sign == b_sign);
    wire a_larger = (a_mag >= b_mag);
    
    // Magnitude processing
    wire [N-1:0] mag_result;  // Extra bit for carry
    wire result_sign;
    
    always @(*) begin
        if (signs_equal) begin
            // Addition case
            mag_result = {1'b0, a_mag} + {1'b0, b_mag};
            result_sign = a_sign;
        end else begin
            // Subtraction case
            if (a_larger) begin
                mag_result = {1'b0, a_mag} - {1'b0, b_mag};
                result_sign = a_sign;
            end else begin
                mag_result = {1'b0, b_mag} - {1'b0, a_mag};
                result_sign = b_sign;
            end
        end
    end

    // Overflow detection and saturation
    wire overflow = mag_result[N-1];  // Carry into sign bit
    wire [N-2:0] max_mag = {N-1{1'b1}};  // Maximum representable magnitude
    
    wire [N-2:0] final_mag = overflow ? max_mag : mag_result[N-2:0];
    wire final_sign = overflow ? result_sign : (|final_mag ? result_sign : 1'b0);

    // Convert back to two's complement
    assign c = {final_sign, final_sign ? -final_mag : final_mag};

endmodule