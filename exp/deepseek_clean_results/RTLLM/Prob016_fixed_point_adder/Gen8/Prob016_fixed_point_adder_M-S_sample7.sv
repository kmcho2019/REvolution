module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire [N:0] sum_ext;  // Extended sum for overflow detection
    wire overflow;

    // Perform extended addition
    assign sum_ext = {a[N-1], a} + {b[N-1], b};
    assign overflow = (sum_ext[N] != sum_ext[N-1]);

    always @(*) begin
        if (overflow) begin
            // Saturate to maximum positive or negative value
            c = sum_ext[N] ? {1'b1, {(N-1){1'b0}}} :  // Negative saturation
                           {1'b0, {(N-1){1'b1}}};   // Positive saturation
        end else begin
            // Normal case - truncate to N bits
            c = sum_ext[N-1:0];
        end
    end

endmodule