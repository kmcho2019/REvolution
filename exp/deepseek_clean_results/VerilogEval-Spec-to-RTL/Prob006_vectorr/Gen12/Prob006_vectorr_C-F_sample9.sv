/*
 * HierarchicalBitReverser - Parameterized hierarchical bit reversal
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module HierarchicalBitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

generate
    if (WIDTH <= 4) begin : small_reverse
        // Base case: direct bit reversal for small widths
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse
            assign out[i] = in[WIDTH-1-i];
        end
    end
    else begin : hierarchical_reverse
        // Recursive case: split into halves and reverse
        localparam HALF_WIDTH = WIDTH / 2;
        wire [HALF_WIDTH-1:0] upper_reversed;
        wire [HALF_WIDTH-1:0] lower_reversed;
        
        HierarchicalBitReverser #(HALF_WIDTH) upper_rev (
            .in(in[WIDTH-1:HALF_WIDTH]),
            .out(upper_reversed)
        );
        
        HierarchicalBitReverser #(HALF_WIDTH) lower_rev (
            .in(in[HALF_WIDTH-1:0]),
            .out(lower_reversed)
        );
        
        assign out = {lower_reversed, upper_reversed};
    end
endgenerate

endmodule

// TopModule wrapper maintains original interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);
    
    HierarchicalBitReverser #(
        .WIDTH(8)
    ) bit_reverser_inst (
        .in(in),
        .out(out)
    );

endmodule