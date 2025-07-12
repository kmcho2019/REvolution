module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Calculate out_both
always @(*) begin
    out_both[99] = 0; // No neighbor to the left for in[99]
    for (int i = 0; i < 99; i++) begin
        out_both[i] = in[i] & in[i+1];
    end
end

// Calculate out_any
always @(*) begin
    out_any[0] = 0; // No neighbor to the right for in[0]
    for (int i = 1; i < 100; i++) begin
        out_any[i] = in[i] | in[i-1];
    end
end

// Calculate out_different
always @(*) begin
    for (int i = 0; i < 100; i++) begin
        if (i == 99) begin
            out_different[i] = ~(in[i] ^ in[0]);
        end else begin
            out_different[i] = ~(in[i] ^ in[i+1]);
        end
    end
end

endmodule