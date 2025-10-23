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

// Define a 2-to-1 multiplexer module
module mux2to1(
    input  [15:0] in0,
    input  [15:0] in1,
    input         sel,
    output reg [15:0] out
);
    always @(*) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule

// Define the 9-to-1 multiplexer tree
reg [15:0] mux0_out;
reg [15:0] mux1_out;
reg [15:0] mux2_out;
reg [15:0] mux3_out;

// Level 1
mux2to1 mux0(.in0(a),.in1(b),.sel(sel[0]),.out(mux0_out));
mux2to1 mux1(.in0(c),.in1(d),.sel(sel[0]),.out(mux1_out));
mux2to1 mux2(.in0(e),.in1(f),.sel(sel[0]),.out(mux2_out));
mux2to1 mux3(.in0(g),.in1(h),.sel(sel[0]),.out(mux3_out));

// Level 2
reg [15:0] mux4_out;
reg [15:0] mux5_out;

mux2to1 mux4(.in0(mux0_out),.in1(mux1_out),.sel(sel[1]),.out(mux4_out));
mux2to1 mux5(.in0(mux2_out),.in1(mux3_out),.sel(sel[1]),.out(mux5_out));

// Level 3
reg [15:0] mux6_out;

mux2to1 mux6(.in0(mux4_out),.in1(mux5_out),.sel(sel[2]),.out(mux6_out));

// Final level
reg [15:0] mux7_out;

mux2to1 mux7(.in0(mux6_out),.in1(i),.sel(sel[3]),.out(mux7_out));

// Top-level 2-to-1 multiplexer for unused cases
reg [15:0] all_ones = 16'hFFFF;
reg [15:0] final_out;

mux2to1 mux_final(.in0(mux7_out),.in1(all_ones),.sel(sel[3] & ~sel[2] & ~sel[1] & ~sel[0]),.out(final_out));

always @(*) begin
    if (sel < 9) begin
        out = mux7_out;
    end else begin
        out = all_ones;
    end
end

endmodule