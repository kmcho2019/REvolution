module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;
    
    always @(*) begin
        // Initialize all outputs
        out_both = 100'b0;
        out_any = 100'b0;
        out_different = 100'b0;
        
        // Process each bit
        for (i = 0; i < 100; i = i + 1) begin
            // out_both: check current and left neighbor (except MSB)
            if (i < 99) begin
                out_both[i] = in[i] & in[i+1];
            end
            
            // out_any: check current and right neighbor (except LSB)
            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end
            
            // out_different: check current and left neighbor (with wrap-around)
            if (i == 99) begin
                out_different[i] = in[i] ^ in[0];
            end else begin
                out_different[i] = in[i] ^ in[i+1];
            end
        end
    end

endmodule