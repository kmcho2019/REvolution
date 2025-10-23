module TopModule #(
    parameter IMPLEMENTATION = 0  // 0: direct, 1: buffer, 2: procedural
) (
    input in,
    output out
);

    // Implementation selector using generate
    generate
        if (IMPLEMENTATION == 0) begin : direct
            // Direct assignment with ternary (same functionality)
            assign out = in ? 1'b1 : 1'b0;
        end
        else if (IMPLEMENTATION == 1) begin : buffered
            // Gate-level buffer implementation
            buf b1(out, in);
        end
        else begin : procedural
            // Behavioral implementation
            always @(*) begin
                out = in;
            end
        end
    endgenerate

    /* Alternative implementations commented out:
    // Option 1: Using XOR as buffer (in ^ 0)
    // assign out = in ^ 1'b0;
    
    // Option 2: Using multiplexer concept
    // assign out = in ? 1'b1 : 1'b0;
    */
endmodule