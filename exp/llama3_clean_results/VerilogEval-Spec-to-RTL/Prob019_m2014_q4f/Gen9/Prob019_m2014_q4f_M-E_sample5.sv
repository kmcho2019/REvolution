module TopModule(
    input  in1,
    input  in2,
    output out
);
// Using a lookup table (LUT) to define the circuit behavior
always @(*)
begin
    case ({in1, in2})
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b0;
        default: out = 1'b0;
    endcase
end
// To get the desired output (out = in1 & ~in2), the LUT needs to be adjusted
// According to the truth table of (in1 & ~in2):
// in1 | in2 | out
// ----|----|----
//  0  | 0  | 0
//  0  | 1  | 0
//  1  | 0  | 1
//  1  | 1  | 0
always @(*)
begin
    case ({in1, in2})
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b1;
        2'b11: out = 1'b0;
        default: out = 1'b0;
    endcase
end
endmodule
// However, this can be optimized further by removing the redundant always block
// and directly implementing the required logic in a single always block:
module TopModule(
    input  in1,
    input  in2,
    output out
);
always @(*)
begin
    case ({in1, in2})
        2'b00, 2'b01, 2'b11: out = 1'b0;
        2'b10: out = 1'b1;
        default: out = 1'b0;
    endcase
end
endmodule