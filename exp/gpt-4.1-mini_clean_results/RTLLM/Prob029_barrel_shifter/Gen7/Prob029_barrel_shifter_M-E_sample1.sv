module mux2X1 (
    input  wire d0,
    input  wire d1,
    input  wire sel,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

// Vector 2-to-1 mux for 8 bits
module mux2X1_8bit (
    input  wire [7:0] d0,
    input  wire [7:0] d1,
    input  wire       sel,
    output wire [7:0] y
);
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : bitmux
            mux2X1 mux (.d0(d0[i]), .d1(d1[i]), .sel(sel), .y(y[i]));
        end
    endgenerate
endmodule

module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Function to perform left rotation by N bits on 8-bit input
    function [7:0] left_rotate;
        input [7:0] val;
        input integer shift_amt; // 0 to 7
        begin
            left_rotate = (val << shift_amt) | (val >> (8 - shift_amt));
        end
    endfunction

    wire [7:0] stage1, stage2;

    // Stage 1: shift by 1 if ctrl[0] set, else pass input through
    // This stage rotates left by 1 bit
    wire [7:0] shifted_by_1 = left_rotate(in, 1);
    mux2X1_8bit stage1_mux (
        .d0(in),
        .d1(shifted_by_1),
        .sel(ctrl[0]),
        .y(stage1)
    );

    // Stage 2: shift by 2 if ctrl[1] set, else pass stage1 through
    // Rotate left by 2 bits
    wire [7:0] shifted_by_2 = left_rotate(stage1, 2);
    mux2X1_8bit stage2_mux (
        .d0(stage1),
        .d1(shifted_by_2),
        .sel(ctrl[1]),
        .y(stage2)
    );

    // Stage 3: shift by 4 if ctrl[2] set, else pass stage2 through
    // Rotate left by 4 bits
    wire [7:0] shifted_by_4 = left_rotate(stage2, 4);
    mux2X1_8bit stage3_mux (
        .d0(stage2),
        .d1(shifted_by_4),
        .sel(ctrl[2]),
        .y(out)
    );

endmodule