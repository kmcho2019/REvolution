module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;
    
    always @(*) begin
        for (i = 0; i < 100; i++) begin
            // For out_both
            if (i == 99) begin
                out_both[i] = 0;
            end else begin
                out_both[i] = in[i] & in[i+1];
            end
            
            // For out_any
            if (i == 0) begin
                out_any[i] = 0;
            end else begin
                out_any[i] = in[i] | in[i-1];
            end
            
            // For out_different
            if (i == 99) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end
    
endmodule