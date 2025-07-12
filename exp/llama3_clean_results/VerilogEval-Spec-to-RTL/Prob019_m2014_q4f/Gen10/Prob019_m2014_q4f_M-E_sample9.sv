module TopModule(
    input in1,
    input in2,
    output out
);

// Define the lookup table based on the truth table of the circuit
// in1  | in2  | out
// ----|----|----
//  0  |  0  | 0
//  0  |  1  | 0
//  1  |  0  | 1
//  1  |  1  | 0

wire [1:0] inputs;
assign inputs = {in1, in2};

always @(*)
    case(inputs)
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b1;
        2'b11: out = 1'b0;
    endcase

endmodule