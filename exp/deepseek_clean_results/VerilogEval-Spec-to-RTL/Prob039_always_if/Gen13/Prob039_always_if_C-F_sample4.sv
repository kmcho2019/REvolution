module TopModule (
    input  a,         // First input
    input  b,         // Second input
    input  sel_b1,    // First select signal for b
    input  sel_b2,    // Second select signal for b
    output out_assign,// Output using continuous assignment
    output reg out_always // Output using procedural block
);

    // Continuous assignment implementation:
    // Uses ternary operator for concise 2-to-1 mux
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural implementation:
    // Uses if-else for clear decision structure
    always @(*) begin
        if (sel_b1 & sel_b2) begin
            out_always = b;
        end
        else begin
            out_always = a;
        end
    end
endmodule