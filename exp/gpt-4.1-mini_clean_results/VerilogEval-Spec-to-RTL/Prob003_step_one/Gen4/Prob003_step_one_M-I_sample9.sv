module TopModule(output wire one);
    // Implicit continuous assignment in port declaration ensures 'one' is always logic high.
    assign one = 1'b1;
endmodule