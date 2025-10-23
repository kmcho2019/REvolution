module TopModule #(
    parameter USE_ASSIGN = 1  // Parameter to select implementation style
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Common implementation for both outputs
    wire and_result = a & b;
    
    // Assign implementation (always generated)
    assign out_assign = and_result;
    
    // Always block implementation (always generated)
    reg always_out;
    always @(*) always_out = and_result;
    assign out_alwaysblock = always_out;
    
    // Alternative conditional implementation (demonstrates parameter use)
    // This part shows how we could select between implementations,
    // though we keep both active in this solution to meet requirements
    /*
    generate
        if (USE_ASSIGN) begin
            assign out_assign = a & b;
        end
        else begin
            reg assign_out;
            always @(*) assign_out = a & b;
            assign out_assign = assign_out;
        end
    endgenerate
    */
endmodule