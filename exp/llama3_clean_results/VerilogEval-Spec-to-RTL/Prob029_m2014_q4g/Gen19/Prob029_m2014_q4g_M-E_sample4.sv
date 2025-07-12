module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Implement XNOR using AND, OR, and NOT gates
wire xnor_out;
assign xnor_out = (in1 && in2) || (!(in1) && !(in2));

// Implement XOR using AND, OR, and NOT gates with xnor_out and in3
assign out = (xnor_out && !(in3)) || (!(xnor_out) && in3);

endmodule