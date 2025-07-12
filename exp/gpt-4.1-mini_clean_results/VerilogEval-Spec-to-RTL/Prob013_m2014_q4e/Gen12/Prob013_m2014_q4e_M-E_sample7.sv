module TopModule (
    input  wire in1,
    input  wire in2,
    output reg  out
);

    always @(*) begin
        out = ~(in1 | in2);
    end

endmodule