// mux2X1 submodule
module mux2X1(
    input   sel,
    input   in0,
    input   in1,
    output  out
);
    assign out = sel? in1 : in0;
endmodule

// barrel_shifter module
module barrel_shifter(
    input   [7:0] in,
    input   [2:0] ctrl,
    output  [7:0] out
);

    // Stage 1: Shift by 4 positions
    wire [7:0] shift4;
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_shift4(
               .sel(ctrl[2]),
               .in0(in[i]),
               .in1(i >= 4? in[i - 4] : 1'b0),
               .out(shift4[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 positions
    wire [7:0] shift2;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_shift2(
               .sel(ctrl[1]),
               .in0(shift4[i]),
               .in1(i >= 2? shift4[i - 2] : 1'b0),
               .out(shift2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 position
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux_shift1(
               .sel(ctrl[0]),
               .in0(shift2[i]),
               .in1(i >= 1? shift2[i - 1] : 1'b0),
               .out(out[i])
            );
        end
    endgenerate

endmodule