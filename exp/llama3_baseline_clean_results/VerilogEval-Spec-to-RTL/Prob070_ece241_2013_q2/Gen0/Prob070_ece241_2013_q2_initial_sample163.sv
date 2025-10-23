module TopModule(a, b, c, d, out_sop, out_pos);
    input a, b, c, d;
    output out_sop, out_pos;

    // Minimum sum-of-products form
    assign out_sop = (a && !b && c && !d) || (!a && b && c && d) || (a && b && c && d);

    // Minimum product-of-sums form
    assign out_pos = (!(!a && !b && !c && !d)) && 
                     (!(!a && !b && !c && d)) &&
                     (!(!a && !b && c && !d)) &&
                     (!(!a && !b && c && d)) &&
                     (!(!a && b && !c && !d)) &&
                     (!(!a && b && !c && d)) &&
                     (!(!a && b && c && !d)) &&
                     (!(!a && b && c && d)) &&
                     (!(a && !b && !c && !d)) &&
                     (!(a && !b && !c && d)) &&
                     (!(a && !b && c && !d));
endmodule