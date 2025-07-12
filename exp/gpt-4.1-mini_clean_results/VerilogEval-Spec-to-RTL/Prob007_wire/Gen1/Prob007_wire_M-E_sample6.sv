module TopModule (
    input  in,
    output out
);

wire zero = 1'b0;
wire sel = 1'b1;

assign out = sel ? in : zero;

endmodule