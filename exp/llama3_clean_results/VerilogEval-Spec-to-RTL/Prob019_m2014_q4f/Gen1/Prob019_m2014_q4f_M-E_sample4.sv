module TopModule(
    input in1,
    input in2,
    output out
);

// Define a look-up table for the function
// The LUT is essentially a case statement that maps inputs to outputs
always @(*) begin
    case ({in1, in2})
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b1;
    endcase
end

endmodule