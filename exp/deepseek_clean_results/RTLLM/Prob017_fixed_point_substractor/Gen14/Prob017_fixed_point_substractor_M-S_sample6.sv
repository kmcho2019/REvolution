module fixed_point_subtractor #(
    parameter N = 32,        // Total number of bits
    parameter Q = 16         // Number of fractional bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Direct subtraction with zero handling
    assign c = (a == b) ? {1'b0, {(N-1){1'b0}}} : (a - b);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Fractional bits Q must be less than total bits N");
        end
    end

endmodule