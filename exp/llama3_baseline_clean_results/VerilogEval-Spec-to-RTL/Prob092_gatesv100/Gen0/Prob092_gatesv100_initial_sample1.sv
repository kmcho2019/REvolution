module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        // out_both: check if current bit and left neighbor are both '1'
        if (i == 99) begin
            out_both[99] = 0; // no left neighbor for in[99]
        end else begin
            out_both[i] = in[i] && in[i + 1];
        end
        
        // out_any: check if current bit or right neighbor is '1'
        if (i == 0) begin
            out_any[0] = 0; // no right neighbor for in[0]
        end else begin
            out_any[i] = in[i] || in[i - 1];
        end
        
        // out_different: check if current bit is different from left neighbor (wrap around)
        if (i == 99) begin
            out_different[99] = in[99] != in[0]; // left neighbor of in[99] is in[0]
        end else begin
            out_different[i] = in[i] != in[i + 1];
        end
    end
end

endmodule