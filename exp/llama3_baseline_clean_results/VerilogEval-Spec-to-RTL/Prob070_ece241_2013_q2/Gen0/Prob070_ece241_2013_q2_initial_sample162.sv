module TopModule(a, b, c, d, out_sop, out_pos);
    input a, b, c, d;
    output out_sop, out_pos;

    // Minimum sum-of-products form
    assign out_sop = (b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Complement of the function in minimum sum-of-products form
    assign out_pos = ~( (~a & ~b & ~c & ~d) | 
                       (~a & ~b & c & ~d) | 
                       (~a & b & ~c & ~d) | 
                       (~a & ~b & ~c & d) | 
                       (~a & ~b & c & d) | 
                       (~a & b & c & ~d) | 
                       (~a & b & ~c & d) | 
                       (~a & ~b & ~c & ~d) | 
                       (a & ~b & ~c & ~d) | 
                       (~a & ~b & ~c & d) | 
                       (a & ~b & c & ~d) | 
                       (a & ~b & ~c & d) | 
                       (~a & ~b & c & d) | 
                       (a & b & ~c & ~d) | 
                       (~a & b & ~c & d) );

    // Minimum product-of-sums form
    // Applying De Morgan's laws
    // Using the property that ~(A+B) = ~A * ~B and ~(A*B) = ~A + ~B
    assign out_pos = (~(~a & ~b & ~c & ~d) & 
                     ~(~a & ~b & c & ~d) & 
                     ~(~a & b & ~c & ~d) & 
                     ~(~a & ~b & ~c & d) & 
                     ~(~a & ~b & c & d) & 
                     ~(~a & b & c & ~d) & 
                     ~(~a & b & ~c & d) & 
                     ~(~a & ~b & ~c & ~d) & 
                     ~(a & ~b & ~c & ~d) & 
                     ~(~a & ~b & ~c & d) & 
                     ~(a & ~b & c & ~d) & 
                     ~(a & ~b & ~c & d) & 
                     ~(~a & ~b & c & d) & 
                     ~(a & b & ~c & ~d) & 
                     ~(~a & b & ~c & d));

    // Simplifying using the properties of Boolean algebra
    // However, it is more complex to simplify it in this form.
    // A more efficient way is to find the sum of product terms for the complement of the function,
    // then apply De Morgan's laws to get the product of sum terms.

endmodule