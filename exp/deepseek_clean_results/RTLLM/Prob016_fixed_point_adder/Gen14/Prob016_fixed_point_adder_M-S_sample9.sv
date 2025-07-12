module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign - simple addition
            c = a + b;
            c[N-1] = a[N-1]; // Maintain sign bit
        end
        else begin
            // Different signs - absolute value subtraction
            if (a[N-2:0] >= b[N-2:0]) begin
                c = a - b;
                c[N-1] = a[N-1]; // Result takes sign of larger magnitude
            end
            else begin
                c = b - a;
                c[N-1] = b[N-1]; // Result takes sign of larger magnitude
            end
        end
    end

endmodule