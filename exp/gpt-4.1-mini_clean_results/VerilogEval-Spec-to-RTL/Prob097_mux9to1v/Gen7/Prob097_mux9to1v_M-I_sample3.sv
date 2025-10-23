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

    wire [15:0] mux0_out;
    wire [15:0] mux1_out;
    wire [15:0] mux2_out;

    // Lower two bits of sel select one input from each group of three
    // Group 0: a(0), b(1), c(2)
    // Group 1: d(3), e(4), f(5)
    // Group 2: g(6), h(7), i(8)
    // Use 2-bit select sel[1:0] for each 3-to-1 mux

    function [15:0] mux3to1;
        input [15:0] in0, in1, in2;
        input [1:0]  sel2;
        begin
            case (sel2)
                2'd0: mux3to1 = in0;
                2'd1: mux3to1 = in1;
                2'd2: mux3to1 = in2;
                default: mux3to1 = 16'hFFFF; // Out of range for 3 inputs
            endcase
        end
    endfunction

    assign mux0_out = mux3to1(a, b, c, sel[1:0]);
    assign mux1_out = mux3to1(d, e, f, sel[1:0]);
    assign mux2_out = mux3to1(g, h, i, sel[1:0]);

    // Final 3-to-1 mux selects among mux0_out, mux1_out, mux2_out using sel[3:2]
    // For sel >= 9 (sel=1001b to 1111b), output 16'hFFFF
    // Note: valid sel range for mux tree is 0 to 8 inclusive

    wire [15:0] final_mux_out;

    always @(*) begin
        if (sel < 4'd9) begin
            case(sel[3:2])
                2'd0: final_mux_out = mux0_out;
                2'd1: final_mux_out = mux1_out;
                2'd2: final_mux_out = mux2_out;
                default: final_mux_out = 16'hFFFF; // sel=12..15
            endcase
        end else begin
            final_mux_out = 16'hFFFF;
        end
    end

    assign out = final_mux_out;

endmodule