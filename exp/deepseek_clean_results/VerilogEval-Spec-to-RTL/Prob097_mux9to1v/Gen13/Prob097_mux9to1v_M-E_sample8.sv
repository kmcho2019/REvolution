module TopModule (
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

// Function for 3-to-1 mux to be reused
function [15:0] mux3to1;
    input [15:0] in0, in1, in2;
    input [1:0] sel;
    begin
        case (sel)
            2'd0: mux3to1 = in0;
            2'd1: mux3to1 = in1;
            2'd2: mux3to1 = in2;
            default: mux3to1 = 16'hFFFF;
        endcase
    end
endfunction

// First level muxes
wire [15:0] mux0_out = mux3to1(a, b, c, sel[1:0]);
wire [15:0] mux1_out = mux3to1(d, e, f, sel[1:0]);
wire [15:0] mux2_out = mux3to1(g, h, i, sel[1:0]);

// Second level mux
wire [15:0] final_mux = mux3to1(mux0_out, mux1_out, mux2_out, sel[3:2]);

// Output with invalid case handling
assign out = (sel > 4'd8) ? 16'hFFFF : final_mux;

endmodule