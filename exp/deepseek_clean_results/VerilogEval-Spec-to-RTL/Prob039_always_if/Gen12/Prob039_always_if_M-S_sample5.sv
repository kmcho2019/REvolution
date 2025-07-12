module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Assign-based mux with direct condition
    assign out_assign = (sel_b1 & sel_b2) ? b : a;
    
    // Always-based mux with same direct condition
    always @(*) begin
        out_always = (sel_b1 & sel_b2) ? b : a;
    end
endmodule