module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_modified = b ^ {8{do_sub}};
    wire carry_in = do_sub;
    
    // Generate and propagate terms
    wire [7:0] g = a & b_modified;
    wire [7:0] p = a | b_modified;
    
    // First level prefix computation
    wire [7:0] g1, p1;
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    assign {g1[7:1], p1[7:1]} = {g[7:1] | (p[7:1] & g[6:0]), 
                                p[7:1] & p[6:0]};
    
    // Second level prefix computation
    wire [7:0] g2, p2;
    assign {g2[1:0], p2[1:0]} = {g1[1:0], p1[1:0]};
    assign {g2[7:2], p2[7:2]} = {g1[7:2] | (p1[7:2] & {2{g1[1:0]}}), 
                                 p1[7:2] & {2{p1[1:0]}}};
    
    // Final carry computation
    wire [8:0] carry;
    assign carry[0] = carry_in;
    assign carry[8:1] = g2 | (p2 & {8{carry[0]}});
    
    // Sum and zero computation
    assign out = a ^ b_modified ^ carry[7:0];
    assign result_is_zero = ~(|out);

endmodule