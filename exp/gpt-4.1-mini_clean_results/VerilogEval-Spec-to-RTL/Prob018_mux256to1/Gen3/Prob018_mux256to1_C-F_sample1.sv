module FourToOneMux(
    input  wire in0,
    input  wire in1,
    input  wire in2,
    input  wire in3,
    input  wire [1:0] sel,
    output wire out
);
    // 4-to-1 mux using a simple combinational assignment
    assign out = (sel == 2'd0) ? in0 :
                 (sel == 2'd1) ? in1 :
                 (sel == 2'd2) ? in2 :
                                 in3 ;
endmodule

module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Level 0: 256 inputs grouped into 64 groups of 4 -> 64 outputs
    wire [63:0] level0;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level0
            FourToOneMux mux0 (
                .in0(in[4*i]),
                .in1(in[4*i+1]),
                .in2(in[4*i+2]),
                .in3(in[4*i+3]),
                .sel(sel[1:0]),
                .out(level0[i])
            );
        end
    endgenerate

    // Level 1: 64 inputs grouped into 16 groups of 4 -> 16 outputs
    wire [15:0] level1;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level1
            FourToOneMux mux1 (
                .in0(level0[4*i]),
                .in1(level0[4*i+1]),
                .in2(level0[4*i+2]),
                .in3(level0[4*i+3]),
                .sel(sel[3:2]),
                .out(level1[i])
            );
        end
    endgenerate

    // Level 2: 16 inputs grouped into 4 groups of 4 -> 4 outputs
    wire [3:0] level2;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level2
            FourToOneMux mux2 (
                .in0(level1[4*i]),
                .in1(level1[4*i+1]),
                .in2(level1[4*i+2]),
                .in3(level1[4*i+3]),
                .sel(sel[5:4]),
                .out(level2[i])
            );
        end
    endgenerate

    // Level 3: 4 inputs grouped into 1 group of 4 -> 1 output
    FourToOneMux mux3 (
        .in0(level2[0]),
        .in1(level2[1]),
        .in2(level2[2]),
        .in3(level2[3]),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule