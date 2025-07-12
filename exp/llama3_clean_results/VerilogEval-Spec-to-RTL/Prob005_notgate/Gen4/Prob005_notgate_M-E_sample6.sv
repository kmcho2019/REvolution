module TopModule(
    input  in,
    output out
);

// Using a 2-to-1 MUX to implement a NOT gate
// The select signal is fixed to 1, which means the MUX will always select the inverse of 'in'
wire not_in; // Internal wire to hold the inverse of 'in'
assign not_in = ~in; // Invert the input

// 2-to-1 MUX implementation
// out = in when select = 0, out = not_in when select = 1
assign out = (1)? not_in : in;

endmodule