module TopModule(
    input  in1,
    input  in2,
    output out
);

// Implementing the logic using a lookup table approach
always @(*)
begin
    case ({in1, in2})
        2'b00: out = 1'b0; // (in1=0, in2=0) => out = 0
        2'b01: out = 1'b0; // (in1=0, in2=1) => out = 0
        2'b10: out = 1'b1; // (in1=1, in2=0) => out = 1
        2'b11: out = 1'b0; // (in1=1, in2=1) => out = 0
    endcase
end

endmodule