module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output wire out
);

    // Implement the logic as a behavioral continuous assignment using built-in operators
    assign out = (in1 ~^ in2) ^ in3;

endmodule