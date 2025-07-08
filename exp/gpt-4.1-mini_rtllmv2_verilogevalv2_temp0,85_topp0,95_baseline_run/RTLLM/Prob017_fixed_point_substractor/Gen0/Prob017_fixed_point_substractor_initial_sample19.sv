module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-2:0] a_mag;
    reg [N-2:0] b_mag;
    reg [N-2:0] mag_diff;
    reg [N-2:0] mag_sum;
    reg         sign_a;
    reg         sign_b;
    reg         sign_res;
    reg [N-1:0] res;

    // Function to compute magnitude (absolute value) of signed fixed-point input
    function [N-2:0] abs_mag;
        input [N-1:0] val;
        begin
            if(val[N-1] == 1'b1) // negative number
                abs_mag = (~val[N-2:0]) + 1'b1;
            else
                abs_mag = val[N-2:0];
        end
    endfunction

    // Function to compare two magnitudes (N-1 bits) 
    // returns 1 if mag_a >= mag_b, else 0
    function mag_ge;
        input [N-2:0] mag_a;
        input [N-2:0] mag_b;
        begin
            mag_ge = (mag_a >= mag_b);
        end
    endfunction

    always @(*) begin
        sign_a = a[N-1];
        sign_b = b[N-1];

        a_mag = abs_mag(a);
        b_mag = abs_mag(b);

        if(sign_a == sign_b) begin
            // Same sign: subtract magnitudes
            if(mag_ge(a_mag, b_mag)) begin
                mag_diff = a_mag - b_mag;
                sign_res = sign_a;
            end else begin
                mag_diff = b_mag - a_mag;
                // Result sign same as inputs, so same sign as a and b
                // But subtraction flipped, so sign flips as well.
                // Problem states sign of result same as inputs, so here sign_res = sign_a
                // but since magnitude is swapped, result sign flips:
                sign_res = sign_a; 
                // Actually since sign_a == sign_b, sign of result same as inputs,
                // but magnitude is smaller first - result should keep same sign.
                // For subtraction of same sign operands: result sign is same as inputs.
                // So keep sign_res = sign_a.
            end
            res = {sign_res, mag_diff};
        end else begin
            // Different signs: add magnitudes
            mag_sum = a_mag + b_mag;
            // Determine sign of result:
            // If a positive & b negative: result sign positive if a_mag >= b_mag else negative
            // If a negative & b positive: same logic
            if(sign_a == 1'b0 && sign_b == 1'b1) begin
                // a positive, b negative
                if(mag_ge(a_mag, b_mag))
                    sign_res = 1'b0;
                else
                    sign_res = 1'b1;
            end else if(sign_a == 1'b1 && sign_b == 1'b0) begin
                // a negative, b positive
                if(mag_ge(b_mag, a_mag))
                    sign_res = 1'b0;
                else
                    sign_res = 1'b1;
            end else begin
                // Should not happen since signs differ, but safe default
                sign_res = 1'b0;
            end
            res = {sign_res, mag_sum};
        end

        // Handle zero result: if magnitude is zero, set sign bit to 0
        if(res[N-2:0] == {N-1{1'b0}})
            res[N-1] = 1'b0;

        c = res;
    end

endmodule