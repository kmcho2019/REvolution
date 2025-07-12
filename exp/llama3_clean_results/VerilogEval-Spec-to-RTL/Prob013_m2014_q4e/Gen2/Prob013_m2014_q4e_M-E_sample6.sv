module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using an XNOR gate and an inverter to implement a NOR gate
wire xnor_result;
assign xnor_result = ~(in1 ^ in2); // XNOR gate
assign out = ~xnor_result; // Inverter to produce NOR gate behavior

endmodule