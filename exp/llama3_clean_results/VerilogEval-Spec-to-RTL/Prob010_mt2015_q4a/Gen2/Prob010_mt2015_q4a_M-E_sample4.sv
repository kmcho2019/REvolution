module TopModule(
    input x,
    input y,
    output z
);

wire mux_out;
assign mux_out = (y) ? ~x : x;
assign z = mux_out & x;

endmodule