/*
 * Parameterized bit reverser module with recursive implementation
 * Parameters:
 *   WIDTH = 8 (default) - Must be power of 2
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    generate
        if (WIDTH == 2) begin : base_case
            assign out = {in[0], in[1]};
        end
        else begin : recursive_case
            localparam HALF_WIDTH = WIDTH / 2;
            wire [HALF_WIDTH-1:0] upper_reversed;
            wire [HALF_WIDTH-1:0] lower_reversed;
            
            BitReverser #(HALF_WIDTH) upper (
                .in(in[WIDTH-1:HALF_WIDTH]),
                .out(upper_reversed)
            );
            
            BitReverser #(HALF_WIDTH) lower (
                .in(in[HALF_WIDTH-1:0]),
                .out(lower_reversed)
            );
            
            assign out = {lower_reversed, upper_reversed};
        end
    endgenerate

endmodule

// TopModule maintains original 8-bit interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule