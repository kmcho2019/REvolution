module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using the built-in Verilog NOR operator (~|) for better optimization
assign out = ~(in1 | in2);

// Alternatively, using the built-in Verilog NOR operator (~&) for better optimization
// assign out = ~(in1 & in2) would not give the correct NOR operation

// However, if the target technology has a built-in NOR gate, it would be more efficient
// But in standard Verilog, the above expression is the most efficient way to implement a NOR gate

endmodule