module TopModule(
    input [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    wire and_result, or_result, xor_result;
    
    assign and_result = &in;
    assign or_result  = |in;
    assign xor_result = ^in;
    
    always @(*) begin
        out_and = and_result;
        out_or  = or_result;
        out_xor = xor_result;
    end

endmodule