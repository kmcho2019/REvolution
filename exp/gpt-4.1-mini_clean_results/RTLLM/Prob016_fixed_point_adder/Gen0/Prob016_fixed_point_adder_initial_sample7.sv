module fixed_point_adder #(parameter Q=8, parameter N=16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);
    reg [N-2:0] abs_a, abs_b;     // Absolute values without sign bit
    reg [N-1:0] abs_val_a, abs_val_b; // Absolute value with sign restored to zero
    reg [N-1:0] sum_val;
    reg [N-1:0] diff_val;
    reg sign_a, sign_b;
    reg sign_c;
    reg a_greater;

    // Compute absolute values (magnitude) as unsigned numbers
    always @* begin
        sign_a = a[N-1];
        sign_b = b[N-1];
        if(sign_a)
            abs_val_a = (~a) + 1'b1; // two's complement to get absolute value
        else
            abs_val_a = a;
        if(sign_b)
            abs_val_b = (~b) + 1'b1;
        else
            abs_val_b = b;

        if(sign_a == sign_b) begin
            // Same signs: add absolute values
            sum_val = abs_val_a + abs_val_b;
            sign_c = sign_a;

            // Assign result with sign
            // Handle possible carry out by truncating sum_val to N-1 bits
            // If overflow occurs, the MSB of sum_val could be out of range,
            // but we only keep N-1 bits plus sign bit.
            c = {sign_c, sum_val[N-2:0]};
        end else begin
            // Different signs: subtract smaller abs from bigger abs
            if(abs_val_a >= abs_val_b) begin
                diff_val = abs_val_a - abs_val_b;
                sign_c = sign_a; // sign of operand with larger abs
            end else begin
                diff_val = abs_val_b - abs_val_a;
                sign_c = sign_b;
            end
            // If diff_val is zero, force sign to zero (positive zero)
            if(diff_val == 0)
                sign_c = 1'b0;

            c = {sign_c, diff_val[N-2:0]};
        end
    end

endmodule