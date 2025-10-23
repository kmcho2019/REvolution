module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
wire sel_bar;  // inverted select signal
wire a_path;   // path for selecting a
wire b_path;   // path for selecting b

// Invert the select signal
not inv_sel(sel, sel_bar);

// Generate the paths for selecting a and b
and and_a(a, sel_bar, a_path);
and and_b(b, sel, b_path);

// Combine the paths using an OR gate
or or_out(a_path, b_path, out);

endmodule