module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both[99] = 1'b0;
    assign out_any[0] = 1'b0;
    
    // Generate out_both
    genvar i;
    generate
        for (i = 98; i >= 0; i--) begin
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    
    // Generate out_any
    generate
        for (i = 1; i <= 99; i++) begin
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    
    // Generate out_different
    generate
        for (i = 0; i < 99; i++) begin
            assign out_different[i] = in[i] ^ in[i+1];
        end
        assign out_different[99] = in[99] ^ in[0];
    endgenerate

endmodule