module TopModule #(
    parameter USE_ASSIGN = 1
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Conditional generate block for assign implementation
    generate
        if (USE_ASSIGN) begin : gen_assign
            assign out_assign = a & b;
        end else begin : no_assign
            assign out_assign = 1'b0;
        end
    endgenerate

    // Conditional generate block for always implementation
    generate
        if (!USE_ASSIGN) begin : gen_always
            reg out_reg;
            always @(*) out_reg = a & b;
            assign out_alwaysblock = out_reg;
        end else begin : no_always
            assign out_alwaysblock = 1'b0;
        end
    endgenerate
endmodule