module TopModule(
    input  in1,
    input  in2,
    output out
);

// Direct gate-level implementation with explicit inversion for clarity and efficiency
// and considering the use of alternative logic operators for potential synthesis optimization
assign out = in1 && !in2;

endmodule