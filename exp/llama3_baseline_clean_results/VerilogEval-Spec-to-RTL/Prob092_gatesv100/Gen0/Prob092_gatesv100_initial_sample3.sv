module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(*) begin
        // out_both
        out_both[99] = 1'b0; // As per the problem statement
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] && in[i+1];
        end
        
        // out_any
        out_any[0] = 1'b0; // As per the problem statement
        for (int i = 1; i <= 99; i++) begin
            out_any[i] = in[i] || in[i-1];
        end
        
        // out_different
        for (int i = 98; i >= 0; i--) begin
            out_different[i] = in[i] != in[i+1];
        end
        out_different[99] = in[99] != in[0]; // Wrap around for the last bit
    end

endmodule