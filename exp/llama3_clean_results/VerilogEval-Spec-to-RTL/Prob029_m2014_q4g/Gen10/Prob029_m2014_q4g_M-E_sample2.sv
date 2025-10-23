module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output out
);

// Define a lookup table to map inputs to output
reg [1:0] lut_in;
reg out_lut;

always @(*) begin
    case ({in1, in2})
        2'b00: lut_in = {1'b0, in3};
        2'b01: lut_in = {1'b1, in3};
        2'b10: lut_in = {1'b1, in3};
        2'b11: lut_in = {1'b0, in3};
    endcase
end

always @(*) begin
    case (lut_in)
        2'b00: out_lut = 1'b0;
        2'b01: out_lut = 1'b1;
        2'b10: out_lut = 1'b1;
        2'b11: out_lut = 1'b0;
    endcase
end

assign out = out_lut;

endmodule