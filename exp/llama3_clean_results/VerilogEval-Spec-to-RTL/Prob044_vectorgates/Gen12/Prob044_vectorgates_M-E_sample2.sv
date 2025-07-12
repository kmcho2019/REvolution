module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] bitwise_or;
    wire       logical_or;
    wire [2:0] inv_a, inv_b;

    always_comb begin
        // Compute bitwise-OR of the two input vectors
        bitwise_or = a | b;

        // Compute logical-OR of the two input vectors
        logical_or = (a != 3'b000) || (b != 3'b000);

        // Compute inversion of both vectors
        inv_a = ~a;
        inv_b = ~b;

        // Assign results to output ports
        out_or_bitwise = bitwise_or;
        out_or_logical = logical_or;
        out_not[5:3] = inv_b;
        out_not[2:0] = inv_a;
    end
endmodule