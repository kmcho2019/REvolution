module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Direct index-based 4-to-1 mux combinational logic
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output reg          out
);
    // Intermediate wires for hierarchical mux tree outputs
    wire [63:0] level0_out; // 64 outputs from first level
    wire [15:0] level1_out; // 16 outputs from second level
    wire [3:0]  level2_out; // 4 outputs from third level

    genvar i;

    // Level 0: 64 instances of 4-to-1 muxes selecting among 4 bits of 'in' using sel[1:0]
    generate
        for (i = 0; i < 64; i = i + 1) begin : level0_muxes
            Mux4to1 mux_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level0_out[i])
            );
        end
    endgenerate

    // Level 1: 16 instances of 4-to-1 muxes selecting among 4 bits of level0_out using sel[3:2]
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_muxes
            Mux4to1 mux_inst (
                .in(level0_out[i*4 +: 4]),
                .sel(sel[3:2]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 4 instances of 4-to-1 muxes selecting among 4 bits of level1_out using sel[5:4]
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_muxes
            Mux4to1 mux_inst (
                .in(level1_out[i*4 +: 4]),
                .sel(sel[5:4]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: Final 4-to-1 mux selecting among 4 bits of level2_out using sel[7:6]
    // Implemented using an explicit procedural case statement for clear synthesis hinting
    always @(*) begin
        case(sel[7:6])
            2'd0: out = level2_out[0];
            2'd1: out = level2_out[1];
            2'd2: out = level2_out[2];
            2'd3: out = level2_out[3];
            default: out = 1'b0; // default safety assignment
        endcase
    end

endmodule