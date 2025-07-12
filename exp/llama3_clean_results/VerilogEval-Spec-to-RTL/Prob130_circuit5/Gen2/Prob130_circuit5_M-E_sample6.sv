module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Decoder to generate enable signals for multiplexers
wire [3:0] dec_out;
decoder dec_inst(.in(c), .out(dec_out));

// Multiplexers to select the correct input
wire [3:0] mux_out1, mux_out2, mux_out3, mux_out4;
mux4 mux1(.in0(b), .in1(e), .in2(a), .in3(d), .sel(dec_out[0]), .out(mux_out1));
mux4 mux2(.in0(b), .in1(e), .in2(a), .in3(d), .sel(dec_out[1]), .out(mux_out2));
mux4 mux3(.in0(b), .in1(e), .in2(a), .in3(d), .sel(dec_out[2]), .out(mux_out3));
mux4 mux4(.in0(b), .in1(e), .in2(a), .in3(d), .sel(dec_out[3]), .out(mux_out4));

// Final multiplexer to select between the decoded outputs and the fixed value 'f'
wire [3:0] final_mux_out;
mux2 final_mux(.in0({4{dec_out[0]} ? mux_out1 : {4{1'b0}}}), .in1(4'b1111), .sel(~(dec_out[0] | dec_out[1] | dec_out[2] | dec_out[3])), .out(final_mux_out));

// Output assignment
assign q = final_mux_out;

// Decoder module
module decoder(
    input  [3:0] in,
    output [3:0] out
);
    assign out[0] = (in == 4'b0000);
    assign out[1] = (in == 4'b0001);
    assign out[2] = (in == 4'b0010);
    assign out[3] = (in == 4'b0011);
endmodule

// Mux4 module
module mux4(
    input  [3:0] in0,
    input  [3:0] in1,
    input  [3:0] in2,
    input  [3:0] in3,
    input  [3:0] sel,
    output [3:0] out
);
    assign out = (sel[0] == 1'b1) ? in0 :
                 (sel[1] == 1'b1) ? in1 :
                 (sel[2] == 1'b1) ? in2 :
                 (sel[3] == 1'b1) ? in3 : 4'b0;
endmodule

// Mux2 module
module mux2(
    input  [3:0] in0,
    input  [3:0] in1,
    input  sel,
    output [3:0] out
);
    assign out = sel ? in1 : in0;
endmodule

endmodule