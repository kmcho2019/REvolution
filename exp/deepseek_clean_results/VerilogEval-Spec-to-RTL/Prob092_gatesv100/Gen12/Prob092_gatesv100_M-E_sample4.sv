module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Processing Element module
    module PE #(parameter POS) (
        input [99:0] in,
        output out_both,
        output out_any,
        output out_different
    );
        // Calculate neighbor indices with wrap-around
        localparam LEFT = (POS + 1) % 100;
        localparam RIGHT = (POS == 0) ? 99 : (POS - 1);
        
        // Current bit and neighbors
        wire current = in[POS];
        wire left = in[LEFT];
        wire right = in[RIGHT];
        
        // Output logic
        assign out_both = (POS == 99) ? 1'b0 : (current & left);
        assign out_any = (POS == 0) ? 1'b0 : (current | right);
        assign out_different = current ^ left;
    endmodule

    // Generate 100 parallel processing elements
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : pe_array
            PE #(.POS(i)) pe (
                .in(in),
                .out_both(out_both[i]),
                .out_any(out_any[i]),
                .out_different(out_different[i])
            );
        end
    endgenerate

endmodule