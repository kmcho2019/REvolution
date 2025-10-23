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
    input  [3:0]  sel,
    output [15:0] out
);

    // First level 3-to-1 muxes
    wire [15:0] mux0_out;
    wire [15:0] mux1_out;
    wire [15:0] mux2_out;

    // 2-bit selector for first level muxes (lower 2 bits of sel)
    wire [1:0] sel_low = sel[1:0];

    // First 3-to-1 mux: selects a, b, c
    reg [15:0] mux0_reg;
    always @(*) begin
        case (sel_low)
            2'd0: mux0_reg = a;
            2'd1: mux0_reg = b;
            2'd2: mux0_reg = c;
            default: mux0_reg = 16'hFFFF;
        endcase
    end
    assign mux0_out = mux0_reg;

    // Second 3-to-1 mux: selects d, e, f
    reg [15:0] mux1_reg;
    always @(*) begin
        case (sel_low)
            2'd0: mux1_reg = d;
            2'd1: mux1_reg = e;
            2'd2: mux1_reg = f;
            default: mux1_reg = 16'hFFFF;
        endcase
    end
    assign mux1_out = mux1_reg;

    // Third 3-to-1 mux: selects g, h, i
    reg [15:0] mux2_reg;
    always @(*) begin
        case (sel_low)
            2'd0: mux2_reg = g;
            2'd1: mux2_reg = h;
            2'd2: mux2_reg = i;
            default: mux2_reg = 16'hFFFF;
        endcase
    end
    assign mux2_out = mux2_reg;

    // Second level 3-to-1 mux: selects among mux0_out, mux1_out, mux2_out
    reg [15:0] out_reg;
    always @(*) begin
        case (sel[3:2])
            2'd0: out_reg = mux0_out;    // sel in [0..2]
            2'd1: out_reg = mux1_out;    // sel in [4..6]
            2'd2: out_reg = mux2_out;    // sel in [8..10]
            default: out_reg = 16'hFFFF; // sel in [12..15]
        endcase
    end

    // For invalid sel values >= 9, output 16'hFFFF
    // Note: sel=9 (4'b1001) maps to sel[3:2]=2'd2 and sel_low=1,
    // which corresponds to mux2_out = h; but problem states sel=9 outputs all ones.
    // Therefore, add a conditional override for sel >= 9.
    assign out = (sel <= 4'd8) ? out_reg : 16'hFFFF;

endmodule