module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output reg out_always
);

// Intermediate mux outputs based on individual selectors
wire intermediate1 = sel_b1 ? b : a;
wire intermediate2 = sel_b2 ? b : a;

// Assign output chains the intermediates to realize the 2-to-1 mux logic
assign out_assign = (sel_b1 & sel_b2) ? b : a;

// Create a two-bit select vector
wire [1:0] sel_vector = {sel_b1, sel_b2};

// Procedural mux using case statement
always @(*) begin
    case(sel_vector)
        2'b11: out_always = b;  // Both selectors true, select b
        default: out_always = a; // Otherwise, select a
    endcase
end

endmodule