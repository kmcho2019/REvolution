module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Priority selection logic
    wire select_b = sel_b1 & sel_b2;
    wire select_a = ~select_b;
    
    // Continuous assignment implementation
    assign out_assign = (select_a & a) | (select_b & b);
    
    // Procedural implementation
    reg out_reg;
    always @(*) begin
        case ({select_b, select_a})
            2'b10: out_reg = b;
            2'b01: out_reg = a;
            default: out_reg = 1'bx; // undefined state if both selects are active
        endcase
    end
    assign out_always = out_reg;
    
    // Assertion to ensure mutually exclusive selection
    // (synthesis will optimize this away)
    always @(*) begin
        if (select_a && select_b) begin
            $display("Warning: Both inputs selected simultaneously");
        end
    end
endmodule