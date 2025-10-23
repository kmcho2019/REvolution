module TopModule (
    input  in1,
    input  in2,
    output out
);

wire not_in2;
wire mux_out;

// Invert in2
not U_not (not_in2, in2);

// 2-to-1 MUX: if in2=0 select in1 else select 0 (logic low)
and U_and (mux_out, not_in2, in1);

assign out = mux_out;

endmodule