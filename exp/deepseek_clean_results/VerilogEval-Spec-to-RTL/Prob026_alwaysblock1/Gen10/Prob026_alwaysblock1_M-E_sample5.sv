module TopModule #(
    parameter USE_ASSIGN = 1
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Common logic for both outputs
    wire and_result = a & b;

    // Assign implementation (always generated)
    assign out_assign = and_result;

    // Conditional implementation style for always block
    generate
        if (USE_ASSIGN) begin
            // Alternative implementation using assign inside generate block
            assign out_alwaysblock = and_result;
        end else begin
            // Standard always block implementation
            always @(*) out_alwaysblock = and_result;
        end
    endgenerate

endmodule