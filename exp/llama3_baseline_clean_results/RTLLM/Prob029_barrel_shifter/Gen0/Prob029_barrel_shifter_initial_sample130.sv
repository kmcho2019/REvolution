module mux2X1(sel, in0, in1, out);
    input sel, in0, in1;
    output out;
    reg out;

    always @(sel, in0, in1) begin
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule

module barrel_shifter(in, ctrl, out);
    input [7:0] in;
    input [2:0] ctrl;
    output [7:0] out;

    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: shift4_stage
            mux2X1 mux4(
                .sel(ctrl[2]),
                .in0(in[i]),
                .in1(i >= 4 ? in[i-4] : 1'b0),
                .out(shift4[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 positions
    generate
        for (i = 0; i < 8; i = i + 1) begin: shift2_stage
            mux2X1 mux2(
                .sel(ctrl[1]),
                .in0(shift4[i]),
                .in1(i >= 2 ? shift4[i-2] : 1'b0),
                .out(shift2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 position
    generate
        for (i = 0; i < 8; i = i + 1) begin: shift1_stage
            mux2X1 mux1(
                .sel(ctrl[0]),
                .in0(shift2[i]),
                .in1(i >= 1 ? shift2[i-1] : 1'b0),
                .out(shift1[i])
            );
        end
    endgenerate

    assign out = shift1;
endmodule