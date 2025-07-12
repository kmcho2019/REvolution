module TopModule (
    input  wire in1,
    input  wire in2,
    input  wire in3,
    output reg  out
);
    always @(*) begin
        out = ((in1 == in2) ^ in3);
    end
endmodule