module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output reg [15:0] out
);

reg [15:0] mux_out1, mux_out2, mux_out3, mux_out4, mux_out5;

always @(*) begin
    // Level 1
    mux_out1 = (sel[0] == 1'b0) ? a : b;
    mux_out2 = (sel[0] == 1'b0) ? c : d;
    mux_out3 = (sel[0] == 1'b0) ? e : f;
    mux_out4 = (sel[0] == 1'b0) ? g : h;

    // Level 2
    mux_out5 = (sel[1] == 1'b0) ? mux_out1 : mux_out2;
    out = (sel[1] == 1'b0) ? mux_out3 : mux_out4;

    // Final selection
    case (sel[3:2])
        2'b00: out = mux_out5;
        2'b01: out = i;
        default: out = 16'hFFFF;
    endcase
end

endmodule