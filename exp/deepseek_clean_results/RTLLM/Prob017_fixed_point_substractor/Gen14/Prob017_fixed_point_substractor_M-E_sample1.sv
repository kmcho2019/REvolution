module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1 : b[N-2:0];

    reg [N-1:0] temp_res;
    reg res_sign;

    always @(*) begin
        // Case 1: Same signs - subtract magnitudes
        if (a_sign == b_sign) begin
            if (a_mag >= b_mag) begin
                temp_res = a_mag - b_mag;
                res_sign = a_sign;
            end else begin
                temp_res = b_mag - a_mag;
                res_sign = ~a_sign;
            end
        end
        // Case 2: Different signs - add magnitudes
        else begin
            temp_res = a_mag + b_mag;
            res_sign = a_sign;
        end

        // Handle zero explicitly
        if (temp_res == 0)
            res_sign = 0;

        // Handle overflow
        if (temp_res[N-2:0] > {1'b0, {(N-2){1'b1}}}) begin
            temp_res = {(N-1){1'b1}};
            res_sign = temp_res[N-1];
        end

        // Combine sign and magnitude
        c = {res_sign, res_sign ? ~temp_res[N-2:0] + 1 : temp_res[N-2:0]};
    end

endmodule