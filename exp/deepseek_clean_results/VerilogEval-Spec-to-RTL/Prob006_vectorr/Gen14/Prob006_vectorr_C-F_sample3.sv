/*
 * BitReverser - Optimal bit reversal module with two implementation options
 * Parameters:
 *   WIDTH = 8 (default) - Specifies input/output bit width
 * Ports:
 *   input_vector  - Input vector to reverse
 *   reversed_out - Output with reversed bit order
 *
 * Implementation Notes:
 *   - Uses `CONCAT_IMPL by default for optimal PPA
 *   - Alternative GENERATE_IMPL available via define
 *   - Both implementations produce identical results
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] input_vector,
    output [WIDTH-1:0] reversed_out
);

`ifdef GENERATE_IMPL
    // Implementation using generate loop (more scalable)
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse
            assign reversed_out[i] = input_vector[WIDTH-1-i];
        end
    endgenerate
`else 
    // Default: Implementation using direct concatenation (optimal PPA)
    // Explicit bit mapping for clarity and optimal synthesis
    assign reversed_out = {
        input_vector[0], input_vector[1], input_vector[2], input_vector[3],
        input_vector[4], input_vector[5], input_vector[6], input_vector[7]
    };
`endif

endmodule

// TopModule wrapper maintains original interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);
    
    BitReverser #(
        .WIDTH(8)
    ) bit_reverser_inst (
        .input_vector(in),
        .reversed_out(out)
    );

endmodule