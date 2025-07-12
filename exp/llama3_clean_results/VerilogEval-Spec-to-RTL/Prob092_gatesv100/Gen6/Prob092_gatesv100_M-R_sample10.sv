module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // Initialize outputs
        out_both = {100{1'b0}};
        out_any = {100{1'b0}};
        out_different = {100{1'b0}};

        // Compute outputs
        for (int i = 0; i < 100; i++) begin
            // Compute out_both
            if (i < 99) begin
                out_both[i] = in[i] & in[i+1];
            end
            
            // Compute out_any
            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end
            
            // Compute out_different, considering wrap-around for in[99]
            out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    end

endmodule