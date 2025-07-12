module TopModule (
    input d,
    input ena,
    output q
);

wire mux_out;

assign mux_out = ena ? d : q;
assign q = mux_out;

endmodule