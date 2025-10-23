module TopModule(
    input  in1,
    input  in2,
    output out
);

reg [1:0] lut_input;
reg out;

always @(*) begin
    case (lut_input)
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b1;
    endcase
end

assign lut_input = {in1, ~in2};

endmodule