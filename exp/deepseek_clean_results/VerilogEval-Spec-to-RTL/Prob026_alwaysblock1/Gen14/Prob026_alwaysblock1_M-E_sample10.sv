module TopModule #(
    parameter USE_ASSIGN = 1  // Parameter to select implementation style
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    
    // Common intermediate signal
    wire and_result = a & b;
    
    // Assign implementation (unconditional)
    assign out_assign = and_result;
    
    // Always block implementation with parameter control
    generate
        if (USE_ASSIGN) begin
            // Alternative implementation using assign for comparison
            assign out_alwaysblock = and_result;
        end else begin
            // Standard always block implementation
            reg out_reg;
            always @(*) out_reg = and_result;
            assign out_alwaysblock = out_reg;
        end
    endgenerate

endmodule