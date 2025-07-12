module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// out_both: check if current bit and its neighbor to the left are both '1'
always @(*) begin
    out_both[99] = 1'b0; // no neighbor to the left for in[99]
    for (int i = 0; i < 99; i++) begin
        out_both[i] = in[i] & in[i+1];
    end
end

// out_any: check if current bit or its neighbor to the right is '1'
always @(*) begin
    out_any[0] = 1'b0; // no neighbor to the right for in[0]
    for (int i = 1; i < 100; i++) begin
        out_any[i] = in[i] | in[i-1];
    end
end

// out_different: check if current bit is different from its neighbor to the left
always @(*) begin
    for (int i = 0; i < 99; i++) begin
        out_different[i] = ~(in[i] ^ in[i+1]);
    end
    out_different[99] = ~(in[99] ^ in[0]); // wrap around for in[99]
end

endmodule