module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;

generate
    for (i = 0; i < 100; i++) begin
        // out_both
        if (i == 99) begin
            assign out_both[99] = 0; // no neighbour to the left
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end
        
        // out_any
        if (i == 0) begin
            assign out_any[0] = 0; // no neighbour to the right
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end
        
        // out_different
        if (i == 99) begin
            assign out_different[99] = in[99] ^ in[0]; // wrap around
        end else begin
            assign out_different[i] = in[i] ^ in[i+1];
        end
    end
endgenerate

endmodule