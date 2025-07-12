module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Direct computation of result using chained conditional operators
    assign c = (a[N-1] == b[N-1]) ? 
                  {a[N-1], a[N-2:0] + b[N-2:0]} :       // Same signs: add magnitudes
               (a[N-2:0] > b[N-2:0]) ? 
                  {a[N-1], a[N-2:0] - b[N-2:0]} :       // Different signs, |a| > |b|
                  {b[N-1], b[N-2:0] - a[N-2:0]};        // Different signs, |b| > |a|

endmodule