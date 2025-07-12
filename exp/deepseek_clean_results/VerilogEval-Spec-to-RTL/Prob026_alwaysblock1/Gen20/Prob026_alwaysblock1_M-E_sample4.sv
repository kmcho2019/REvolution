module TopModule #(
    parameter USE_ASSIGN = 1  // Parameter to select implementation style
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Common AND logic
    wire and_result = a & b;
    
    // Assign implementation (unconditionally generated)
    assign out_assign = and_result;
    
    // Conditional implementation style for always block
    generate
        if (USE_ASSIGN) begin : gen_assign_style
            // Alternative implementation using assign
            assign out_alwaysblock = and_result;
        end else begin : gen_always_style
            // Implementation using always block
            reg out_reg;
            always @(*) out_reg = and_result;
            assign out_alwaysblock = out_reg;
        end
    endgenerate
endmodule