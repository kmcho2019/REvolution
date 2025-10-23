module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

assign z = x ~^ y;  // XNOR operation using built-in operator

endmodule