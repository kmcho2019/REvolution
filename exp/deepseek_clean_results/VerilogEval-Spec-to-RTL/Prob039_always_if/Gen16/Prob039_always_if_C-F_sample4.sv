module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Combinational implementation using assign
    assign out_assign = (sel_b1 & sel_b2) ? b : a;

    // Procedural implementation with explicit sensitivity list
    always @(a or b or sel_b1 or sel_b2) begin
        out_always = (sel_b1 & sel_b2) ? b : a;
    end
endmodule