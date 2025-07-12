module TopModule (
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out
);

    always @(*) begin
        reg xnor_intermediate;
        xnor_intermediate = ~(in1 ^ in2);
        out = xnor_intermediate ^ in3;
    end

endmodule