module TopModule #(
    parameter USE_ASSIGN_FOR_OUT1 = 1,  // 1=assign, 0=always
    parameter USE_ASSIGN_FOR_OUT2 = 0   // 1=assign, 0=always
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Configurable implementation for out_assign
    generate
        if (USE_ASSIGN_FOR_OUT1) begin : gen_assign1
            assign out_assign = a & b;
        end else begin : gen_always1
            reg out_assign_reg;
            always @(*) begin
                out_assign_reg = a & b;
            end
            assign out_assign = out_assign_reg;
        end
    endgenerate

    // Configurable implementation for out_alwaysblock
    generate
        if (USE_ASSIGN_FOR_OUT2) begin : gen_assign2
            assign out_alwaysblock = a & b;
        end else begin : gen_always2
            reg out_alwaysblock_reg;
            always @(*) begin
                out_alwaysblock_reg = a & b;
            end
            assign out_alwaysblock = out_alwaysblock_reg;
        end
    endgenerate

endmodule