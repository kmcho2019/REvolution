module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: check if current bit and its left neighbor are both '1'
    assign out_both[99] = 1'b0; // no left neighbor for in[99]
    for (genvar i = 0; i < 99; i++) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // out_any: check if current bit or its right neighbor is '1'
    assign out_any[0] = 1'b0; // no right neighbor for in[0]
    for (genvar i = 1; i < 100; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // out_different: check if current bit is different from its left neighbor (circular)
    for (genvar i = 0; i < 100; i++) begin
        assign out_different[i] = in[i] ^ in[(i+1) % 100]; // (i+1) % 100 wraps around to 0 when i is 99
    end

endmodule