module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: each bit indicates if the input bit and its left neighbor are both '1'
    assign out_both[99] = 1'b0; // no left neighbor for the most significant bit
    for (genvar i = 0; i < 99; i++) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // out_any: each bit indicates if the input bit or its right neighbor is '1'
    assign out_any[0] = 1'b0; // no right neighbor for the least significant bit
    for (genvar i = 1; i < 100; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // out_different: each bit indicates if the input bit is different from its left neighbor, wrapping around for the most significant bit
    for (genvar i = 0; i < 99; i++) begin
        assign out_different[i] = in[i] ^ in[i+1];
    end
    assign out_different[99] = in[99] ^ in[0]; // wrap around for the most significant bit

endmodule