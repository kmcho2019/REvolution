module TopModule (
    input in,
    output out
);

wire sel = 1'b0; // Selector fixed to 0
assign out = sel ? in : in;

endmodule