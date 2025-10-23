module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output reg signed [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign subtraction
            if (a_mag >= b_mag) begin
                res = {a_sign, a_mag - b_mag};
            end else begin
                res = {~a_sign, b_mag - a_mag};
            end
        end else begin
            // Different signs - effectively addition
            res = {a_sign, a_mag} + {b_sign, b_mag};
            
            // Handle sign for different signs
            if (a_sign) begin
                // a is negative, b is positive
                if (a_mag > b_mag) begin
                    res[N-1] = 1'b1;  // Result is negative
                end else begin
                    res[N-1] = 1'b0;  // Result is positive
                end
            end else begin
                // a is positive, b is negative
                if (a_mag >= b_mag) begin
                    res[N-1] = 1'b0;  // Result is positive
                end else begin
                    res[N-1] = 1'b1;  // Result is negative
                end
            end
        end

        // Explicit zero handling
        if (res[N-2:0] == 0) begin
            res[N-1] = 1'b0;
        end

        c = res;
    end

endmodule