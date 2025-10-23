module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Continuous assignment implementation (clear and concise)
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural always implementation (matches "always if" requirement)
    always @(*) begin
        out_always = a;  // Default assignment
        if (sel_b1 & sel_b2) begin
            out_always = b;
        end
    end
endmodule