module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

// 2-to-1 mux function
function automatic mux2to1;
    input sel, in0, in1;
    begin
        mux2to1 = sel ? in1 : in0;
    end
endfunction

// mux_in[0] = for ab=00 column: cd=00:0,01:1,11:1,10:1
// mapping mux_in[0](cd) = (c=0,d=0)->0, (0,1)->1, (1,1)->1, (1,0)->1
// Implement mux_in[0] = d ? 1 : (c ? 1 : 0)
// mux_in[0] = mux2to1(d, 0, mux2to1(c, 0, 1))
// Simplify:
// inner mux: c ? 1 : 0
// outer mux: d ? 1 : (c ? 1 : 0)

wire mux_in0_c_mux = mux2to1(c, 1'b0, 1'b1); // c?1:0
wire mux_in0 = mux2to1(d, mux_in0_c_mux, 1'b1);

// mux_in[1] = all zeros
wire mux_in1 = 1'b0;

// mux_in[2] = for ab=11 column: cd=00:0,01:0,11:1,10:0
// mux_in[2] = (c=0,d=0)->0, (0,1)->0, (1,1)->1, (1,0)->0
// Use c as selector:
// c=0: output=0 regardless d
// c=1: output= d ? 1 : 0
wire mux_in2_c_mux = mux2to1(d, 1'b0, 1'b1); // d?1:0
wire mux_in2 = mux2to1(c, 1'b0, mux_in2_c_mux);

// mux_in[3] = for ab=10 column: cd=00:1,01:0,11:1,10:1
// (c=0,d=0)->1, (0,1)->0, (1,1)->1, (1,0)->1
// Use c as selector:
// c=0: d?0:1
// c=1: d?1:1 = always 1
wire mux_in3_c0 = mux2to1(d, 1'b1, 1'b0); // c=0
wire mux_in3_c1 = 1'b1;                   // c=1
wire mux_in3 = mux2to1(c, mux_in3_c0, mux_in3_c1);

// assign outputs
assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};

endmodule