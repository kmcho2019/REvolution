module fixed_point_adder #(
    parameter Q = 8,      // Number of fractional bits
    parameter N = 16      // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    wire signs_equal = (a_sign == b_sign);
    wire a_larger = (a_mag > b_mag);
    
    reg [N-1:0] res_mag;  // N-1 magnitude bits + 1 sign bit
    reg [N:0] temp_res;   // Extended precision for calculations

    always @(*) begin
        if (signs_equal) begin
            // Same signs: add magnitudes
            temp_res = {1'b0, a_mag} + {1'b0, b_mag};
            res_mag = {a_sign, temp_res[N-2:0]};
        end
        else begin
            // Different signs: subtract smaller from larger
            if (a_larger) begin
                temp_res = {1'b0, a_mag} - {1'b0, b_mag};
                res_mag = {a_sign, temp_res[N-2:0]};
            end
            else begin
                temp_res = {1'b0, b_mag} - {1'b0, a_mag};
                res_mag = {b_sign, temp_res[N-2:0]};
            end
        end
    end

    // Convert back to two's complement
    always @(*) begin
        if (res_mag[N-1]) begin  // Negative result
            c = {1'b1, ~res_mag[N-2:0] + 1'b1};
        end
        else begin               // Positive result
            c = res_mag;
        end
    end

endmodule