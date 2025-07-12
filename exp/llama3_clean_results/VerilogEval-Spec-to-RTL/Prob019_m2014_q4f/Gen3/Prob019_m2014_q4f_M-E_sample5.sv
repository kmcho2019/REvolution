module TopModule(
    input in1,
    input in2,
    output out
);

reg [1:0] lut_input;
reg out;

always @(*) begin
    lut_input = {in1, ~in2};
    case (lut_input)
        2'b10: out = 1'b1;
        default: out = 1'b0;
    endcase
end

assign out = out;

endmodule