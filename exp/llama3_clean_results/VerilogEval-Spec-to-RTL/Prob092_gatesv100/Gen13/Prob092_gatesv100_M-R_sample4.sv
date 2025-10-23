module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize the output vectors
    assign out_both[99] = 1'b0; // Since in[99] has no neighbor to the left
    assign out_any[0] = 1'b0; // Since in[0] has no neighbor to the right

    // Use generate loop for the rest of the bits
    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            // Handle the edge case for out_both and out_any
            if (i < 99) begin
                // Logic for out_both
                assign out_both[i] = in[i] & in[i+1];
                
                // Logic for out_any (except for the first bit which is handled above)
                if (i > 0) begin
                    assign out_any[i] = in[i] | in[i-1];
                end
            end
            
            // Logic for out_different, handling the wrap-around case
            assign out_different[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
        end
    endgenerate

endmodule