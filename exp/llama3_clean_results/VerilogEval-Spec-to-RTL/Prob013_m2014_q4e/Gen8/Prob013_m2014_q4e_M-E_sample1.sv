module TopModule(
    input  logic in1,
    input  logic in2,
    output logic out
);

// Define the LUT for the NOR gate truth table
// in1  | in2  | out
// -----|------|----
// 0    | 0    | 1
// 0    | 1    | 0
// 1    | 0    | 0
// 1    | 1    | 0
always @(*) begin
    case ({in1, in2})
        2'b00: out = 1'b1;
        2'b01, 2'b10, 2'b11: out = 1'b0;
    endcase
end

endmodule