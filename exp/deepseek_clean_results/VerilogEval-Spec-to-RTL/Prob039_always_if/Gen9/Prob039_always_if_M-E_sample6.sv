module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output reg out_always
);
    // Bitwise implementation using masking
    wire [1:0] sel = {sel_b1, sel_b2};
    wire select_mask = &sel;  // AND of both bits
    
    // Assign-based implementation using bitwise operations
    assign out_assign = (a & ~select_mask) | (b & select_mask);
    
    // Always-based implementation using bitwise operations
    always @(*) begin
        out_always = (a & ~select_mask) | (b & select_mask);
    end
endmodule