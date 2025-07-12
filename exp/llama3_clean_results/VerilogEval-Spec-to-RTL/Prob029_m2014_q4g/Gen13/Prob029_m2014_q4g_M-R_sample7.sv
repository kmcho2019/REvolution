module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

wire xnor_result;

assign xnor_result = ~(in1 ^ in2);

always @(*)
begin
    out = xnor_result ^ in3;
end

endmodule