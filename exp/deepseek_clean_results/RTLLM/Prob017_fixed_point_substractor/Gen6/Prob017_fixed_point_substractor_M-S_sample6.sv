module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same signs - perform subtraction
            if (a >= b) begin
                c = a - b;
            end else begin
                c = b - a;
                c[N-1] = ~b[N-1]; // Flip sign
            end
        end else begin
            // Different signs - perform addition
            c = a + {~b[N-1], b[N-2:0]};
        end

        // Handle zero case
        if (c[N-2:0] == 0) c[N-1] = 0;
    end

endmodule