module TopModule(
    input in1,
    input in2,
    output out
);

// Use a case statement within an always block to implement the logic
always @(*) begin
    case ({in1, in2})
        2'b00: out = 1'b0; // in1=0, in2=0
        2'b01: out = 1'b0; // in1=0, in2=1
        2'b10: out = 1'b1; // in1=1, in2=0
        2'b11: out = 1'b0; // in1=1, in2=1
    endcase
end

endmodule