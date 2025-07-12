module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: Both current bit and its neighbor to the left are '1'
    assign out_both[99] = 1'b0; // No neighbor to the left, set to 0
    for (genvar i = 0; i < 99; i++) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // out_any: Either current bit or its neighbor to the right is '1'
    assign out_any[0] = 1'b0; // No neighbor to the right, set to 0
    for (genvar i = 1; i < 100; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // out_different: Current bit is different from its neighbor to the left
    for (genvar i = 1; i < 100; i++) begin
        assign out_different[i] = in[i] ^ in[i-1];
    end
    // Handle wrap-around case for in[99]
    assign out_different[0] = in[0] ^ in[99];

endmodule