module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shared adjacent bit operations
    wire [2:0] adjacent_and = in[2:0] & in[3:1];
    wire [2:0] adjacent_or  = in[3:1] | in[2:0];
    
    // Output assignments
    assign out_both      = {1'b0, adjacent_and};    // out_both[3] is don't care
    assign out_any       = {adjacent_or, 1'b0};     // out_any[0] is don't care
    assign out_different = in ^ {in[0], in[3:1]};   // Circular XOR

endmodule