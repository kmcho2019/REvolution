module TopModule(
    input  in1,
    input  in2,
    output out
);

// Define the lookup table for NOR operation
reg [1:0] lut_out;
always @(*) begin
    case ({in1, in2})
        2'b00: lut_out = 1'b1;
        2'b01: lut_out = 1'b0;
        2'b10: lut_out = 1'b0;
        2'b11: lut_out = 1'b0;
        default: lut_out = 1'bx;
    endcase
end

// Assign the output from the lookup table
assign out = lut_out;

endmodule