module TopModule #(
    parameter USE_ASSIGN = 1  // Parameter to select implementation style
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Configurable implementation using generate blocks
    generate
        if (USE_ASSIGN) begin : assign_impl
            // Direct assignment implementation
            assign out_assign = a & b;
        end
        else begin : assign_alt_impl
            // Alternative implementation using continuous assignment
            wire tmp = a && b;
            assign out_assign = tmp;
        end
    endgenerate

    // Always block implementation with ternary operator
    reg always_out;
    always @(*) begin
        always_out = (a) ? (b ? 1'b1 : 1'b0) : 1'b0;
    end
    assign out_alwaysblock = always_out;

endmodule