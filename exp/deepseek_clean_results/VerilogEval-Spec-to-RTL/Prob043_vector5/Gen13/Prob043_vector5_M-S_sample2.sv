module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);
    // Self comparisons (always 1)
    wire a_eq_a = 1'b1;
    wire b_eq_b = 1'b1;
    wire c_eq_c = 1'b1;
    wire d_eq_d = 1'b1;
    wire e_eq_e = 1'b1;

    // Pairwise comparisons
    wire a_eq_b = a == b;
    wire a_eq_c = a == c;
    wire a_eq_d = a == d;
    wire a_eq_e = a == e;
    
    wire b_eq_c = b == c;
    wire b_eq_d = b == d;
    wire b_eq_e = b == e;
    
    wire c_eq_d = c == d;
    wire c_eq_e = c == e;
    
    wire d_eq_e = d == e;

    // Concatenate all results in order
    assign out = {
        a_eq_a, a_eq_b, a_eq_c, a_eq_d, a_eq_e,
        b_eq_a, b_eq_b, b_eq_c, b_eq_d, b_eq_e,
        c_eq_a, c_eq_b, c_eq_c, c_eq_d, c_eq_e,
        d_eq_a, d_eq_b, d_eq_c, d_eq_d, d_eq_e,
        e_eq_a, e_eq_b, e_eq_c, e_eq_d, e_eq_e
    };
    
    // Aliases for symmetric comparisons
    assign b_eq_a = a_eq_b;
    assign c_eq_a = a_eq_c;
    assign d_eq_a = a_eq_d;
    assign e_eq_a = a_eq_e;
    assign c_eq_b = b_eq_c;
    assign d_eq_b = b_eq_d;
    assign e_eq_b = b_eq_e;
    assign d_eq_c = c_eq_d;
    assign e_eq_c = c_eq_e;
    assign e_eq_d = d_eq_e;
endmodule