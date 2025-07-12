module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define wires for minterms
wire minterm_2;
wire minterm_7;
wire minterm_15;

// Define wires for maxterms
wire maxterm_0;
wire maxterm_1;
wire maxterm_4;
wire maxterm_5;
wire maxterm_6;
wire maxterm_9;
wire maxterm_10;
wire maxterm_13;
wire maxterm_14;

// Assign values to minterms
assign minterm_2 = !a && b && !c && !d;
assign minterm_7 = !a && b && c && d;
assign minterm_15 = a && b && c && d;

// Assign values to maxterms
assign maxterm_0 = !a && !b && !c && !d;
assign maxterm_1 = !a && !b && !c && d;
assign maxterm_4 = !a && b && !c && !d;
assign maxterm_5 = !a && b && !c && d;
assign maxterm_6 = !a && b && c && !d;
assign maxterm_9 = !a && !b && c && d;
assign maxterm_10 = !a && b && c && d;
assign maxterm_13 = a && !b && c && d;
assign maxterm_14 = a && b && !c && d;

// Assign output out_sop using minterms
assign out_sop = minterm_2 || minterm_7 || minterm_15;

// Assign output out_pos using maxterms (duality principle)
assign out_pos = !(maxterm_0 || maxterm_1 || maxterm_4 || maxterm_5 || maxterm_6 || maxterm_9 || maxterm_10 || maxterm_13 || maxterm_14);

endmodule