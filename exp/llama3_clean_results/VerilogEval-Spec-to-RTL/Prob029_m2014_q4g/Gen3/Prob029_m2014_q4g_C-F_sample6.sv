module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Directly calculate the output using intermediate logic for clarity and potential optimization
assign out = (~(in1 ^ in2)) ^ in3;

endmodule