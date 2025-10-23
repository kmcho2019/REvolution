module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    // Bitwise OR implementation using individual gates
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bitwise_or
            or g_or(out_or_bitwise[i], a[i], b[i]);
        end
    endgenerate

    // Intermediate signals for logical OR
    wire a_any, b_any;
    
    // Reduction OR for a
    or g_or_a(a_any, a[0], a[1], a[2]);
    
    // Reduction OR for b
    or g_or_b(b_any, b[0], b[1], b[2]);
    
    // Final logical OR
    or g_final_or(out_or_logical, a_any, b_any);

    // NOT operations using individual inverters
    wire [2:0] not_a, not_b;
    
    generate
        for (i = 0; i < 3; i = i + 1) begin : not_gates
            not g_not_a(not_a[i], a[i]);
            not g_not_b(not_b[i], b[i]);
        end
    endgenerate
    
    // Concatenate results
    assign out_not = {not_b, not_a};

endmodule