module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

// 2-to-1 mux function
function mux2_1;
    input sel;
    input in0;
    input in1;
    begin
        mux2_1 = sel ? in1 : in0;
    end
endfunction

wire not_d;
wire c_or_d;
wire c_and_d;
wire c_or_not_d;

// ~d implemented using mux2_1 with d as select, inputs 1,0
assign not_d = mux2_1(d, 1'b1, 1'b0);

// c + d = mux2_1 with c as select, inputs d,1
assign c_or_d = mux2_1(c, d, 1'b1);

// c & d = mux2_1 with c as select, inputs 0,d
assign c_and_d = mux2_1(c, 1'b0, d);

// c + ~d = mux2_1 with c as select, inputs not_d,1
assign c_or_not_d = mux2_1(c, not_d, 1'b1);

assign mux_in[0] = c_or_d;
assign mux_in[1] = 1'b0;
assign mux_in[2] = c_and_d;
assign mux_in[3] = c_or_not_d;

endmodule