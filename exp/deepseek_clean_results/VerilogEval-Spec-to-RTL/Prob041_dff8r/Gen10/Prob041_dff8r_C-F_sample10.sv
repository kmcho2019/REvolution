/**
 * Parameterized D Flip-Flop with Synchronous Reset
 * @param WIDTH Bit width (default: 1)
 */
module DFF #(
    parameter WIDTH = 1
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Synchronous reset with vector operation
    always @(posedge clk) begin
        q <= reset ? {WIDTH{1'b0}} : d;
    end

endmodule

/**
 * Top Module with Configurable Width
 * @param WIDTH Bit width (default: 8)
 */
module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Implementation selection with synthesis pragmas
    // Option 1: Single vector instance (better for PPA in most cases)
    /* synthesis syn_implementation = "vector" */
    DFF #(.WIDTH(WIDTH)) dff_vector (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    /*
    // Option 2: Generate block (uncomment if needed)
    // Better for specific placement requirements
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_gen
            /* synthesis syn_keep = "true" */
            DFF #(.WIDTH(1)) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
    */

endmodule