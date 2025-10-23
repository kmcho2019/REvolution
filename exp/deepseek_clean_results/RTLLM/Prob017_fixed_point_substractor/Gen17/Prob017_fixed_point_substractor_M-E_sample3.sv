module fixed_point_subtractor #(
    parameter N = 32,
    parameter Q = 16
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    
    // Magnitude conversion (two's complement to absolute value)
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    // Result sign determination
    wire res_sign;
    wire [N-2:0] res_mag;
    
    always @(*) begin
        if (a_sign == b_sign) begin
            // Same signs: subtract magnitudes
            if (a_mag >= b_mag) begin
                res_sign = a_sign;
                res_mag = a_mag - b_mag;
            end else begin
                res_sign = ~a_sign;
                res_mag = b_mag - a_mag;
            end
        end else begin
            // Different signs: add magnitudes
            res_sign = a_sign;
            res_mag = a_mag + b_mag;
        end
    end
    
    // Result reconstruction (sign-magnitude to two's complement)
    assign c = (res_mag == 0) ? 0 : {res_sign, res_sign ? ~res_mag + 1'b1 : res_mag};

endmodule