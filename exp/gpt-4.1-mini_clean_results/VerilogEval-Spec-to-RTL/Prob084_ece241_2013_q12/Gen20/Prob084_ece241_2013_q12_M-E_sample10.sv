module Mux2to1 (
    input wire sel,
    input wire d0,
    input wire d1,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input wire clk,
    input wire enable,
    input wire S,
    input wire A,
    input wire B,
    input wire C,
    output wire Z
);

    reg [7:0] Q;

    // Shift register: shift left, shift in S at Q[0]
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Hierarchical 8-to-1 mux using 2:1 muxes
    wire [3:0] mux_level1;
    wire [1:0] mux_level2;
    wire mux_level3;

    // Level 1: 4 muxes selecting between pairs Q[0..1], Q[2..3], Q[4..5], Q[6..7] controlled by C
    Mux2to1 mux0 (.sel(C), .d0(Q[0]), .d1(Q[1]), .y(mux_level1[0]));
    Mux2to1 mux1 (.sel(C), .d0(Q[2]), .d1(Q[3]), .y(mux_level1[1]));
    Mux2to1 mux2 (.sel(C), .d0(Q[4]), .d1(Q[5]), .y(mux_level1[2]));
    Mux2to1 mux3 (.sel(C), .d0(Q[6]), .d1(Q[7]), .y(mux_level1[3]));

    // Level 2: 2 muxes selecting between outputs from level 1 controlled by B
    Mux2to1 mux4 (.sel(B), .d0(mux_level1[0]), .d1(mux_level1[1]), .y(mux_level2[0]));
    Mux2to1 mux5 (.sel(B), .d0(mux_level1[2]), .d1(mux_level1[3]), .y(mux_level2[1]));

    // Level 3: final mux selecting between outputs from level 2 controlled by A
    Mux2to1 mux6 (.sel(A), .d0(mux_level2[0]), .d1(mux_level2[1]), .y(mux_level3));

    assign Z = mux_level3;

endmodule