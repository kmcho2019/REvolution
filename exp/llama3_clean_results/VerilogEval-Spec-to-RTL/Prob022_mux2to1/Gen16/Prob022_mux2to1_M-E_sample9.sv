// Module declaration for a 2-to-1 multiplexer using basic logic gates
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    input  sel, // Select input
    output out  // Output
);

// Internal wires for the inverted select signal and the AND gate outputs
wire not_sel;  // Inverted select signal
wire a_selected;  // Output of AND gate selecting 'a'
wire b_selected;  // Output of AND gate selecting 'b'

// Invert the select signal
not not_sel_inv(sel, not_sel);

// Use AND gates to select either 'a' or 'b' based on 'sel' and 'not_sel'
and a_and(a, not_sel, a_selected);
and b_and(b, sel, b_selected);

// Use an OR gate to combine the outputs of the AND gates
or out_or(a_selected, b_selected, out);

endmodule