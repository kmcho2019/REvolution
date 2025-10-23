module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);
    reg [2:0] bitwise_or;
    reg logical_or;
    reg [5:0] not_result;

    always @(*) begin
        // Bitwise OR operation
        bitwise_or = a | b;
        
        // Logical OR operation (more efficient implementation)
        logical_or = |(a | b);
        
        // NOT operations with concatenation
        not_result = {~b, ~a};
    end

    assign out_or_bitwise = bitwise_or;
    assign out_or_logical = logical_or;
    assign out_not = not_result;
endmodule