module TopModule(
    input  in1,
    input  in2,
    output out
);

// Internal signal to hold the result of the OR operation
wire or_result;

// OR gate implementation
assign or_result = in1 | in2;

// Inverter to compute NOR from OR
assign out = ~or_result;

endmodule