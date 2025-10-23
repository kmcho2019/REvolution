module TopModule #(
    parameter USE_ASSIGN = 1  // 1 for assign, 0 for always block
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Debug signal (could be tied to 0 in production)
    wire debug = 1'b0;

    // Configurable AND implementation
    generate
        if (USE_ASSIGN) begin : assign_impl
            assign out_assign = (a & b) ^ debug;
        end else begin : always_impl
            reg result;
            always @(*) begin
                result = (a & b) ^ debug;
            end
            assign out_assign = result;
        end
    endgenerate

    // Fixed always block implementation for comparison
    reg always_result;
    always @(*) begin
        always_result = (a & b) ^ debug;
    end
    assign out_alwaysblock = always_result;

endmodule