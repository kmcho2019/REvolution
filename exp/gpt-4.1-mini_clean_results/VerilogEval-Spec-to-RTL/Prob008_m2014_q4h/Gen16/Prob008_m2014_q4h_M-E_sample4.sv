module TopModule (
    input  in,
    output out
);

wire internal_signal;

assign internal_signal = in;
assign out = internal_signal;

endmodule