module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    reg a_sign, b_sign;
    reg [N-2:0] a_mag, b_mag;  // Magnitude parts (without sign)
    reg [N-1:0] temp_res;

    always @(*) begin
        // Extract signs and magnitudes
        a_sign = a[N-1];
        b_sign = b[N-1];
        a_mag = a[N-2:0];
        b_mag = b[N-2:0];

        // Case 1: Both operands have same sign
        if (a_sign == b_sign) begin
            temp_res = {1'b0, a_mag} + {1'b0, b_mag};
            res = {a_sign, temp_res[N-2:0]};  // Keep original sign
        end
        // Case 2: Operands have different signs
        else begin
            if (a_mag > b_mag) begin
                temp_res = {1'b0, a_mag} - {1'b0, b_mag};
                res = {a_sign, temp_res[N-2:0]};  // Take sign of larger magnitude
            end
            else if (b_mag > a_mag) begin
                temp_res = {1'b0, b_mag} - {1'b0, a_mag};
                res = {b_sign, temp_res[N-2:0]};  // Take sign of larger magnitude
            end
            else begin  // Equal magnitudes
                res = 0;  // a + (-a) = 0
            end
        end

        // Handle overflow (only possible in same-sign case)
        if ((a_sign == b_sign) && (temp_res[N-1] != a_sign)) begin
            // Saturate to maximum positive or negative value
            res = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
        end

        c = res;
    end

endmodule