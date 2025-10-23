module Mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // Shift register update on posedge clk, synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S}; // Shift left, S shifted into LSB (Q[0] is LSB)
        end
    end

    // Build an 8-to-1 mux tree for selecting Q[{A,B,C}]
    wire [3:0] mux_level1;
    wire [1:0] mux_level2;
    wire mux_level3;

    // Level 1: 4 muxes, select C
    Mux2to1 mux0 (.sel(C), .d0(Q[0]), .d1(Q[1]), .y(mux_level1[0]));
    Mux2to1 mux1 (.sel(C), .d0(Q[2]), .d1(Q[3]), .y(mux_level1[1]));
    Mux2to1 mux2 (.sel(C), .d0(Q[4]), .d1(Q[5]), .y(mux_level1[2]));
    Mux2to1 mux3 (.sel(C), .d0(Q[6]), .d1(Q[7]), .y(mux_level1[3]));

    // Level 2: 2 muxes, select B
    Mux2to1 mux4 (.sel(B), .d0(mux_level1[0]), .d1(mux_level1[1]), .y(mux_level2[0]));
    Mux2to1 mux5 (.sel(B), .d0(mux_level1[2]), .d1(mux_level1[3]), .y(mux_level2[1]));

    // Level 3: 1 mux, select A
    Mux2to1 mux6 (.sel(A), .d0(mux_level2[0]), .d1(mux_level2[1]), .y(mux_level3));

    assign Z = mux_level3;

endmodule