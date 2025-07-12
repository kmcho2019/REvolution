// Generic latch primitive module declaration (blackbox)
// This should match the latch primitive provided by the synthesis library or be replaced accordingly.
module latch (
    output reg q,
    input d,
    input en
);
    always @(*) begin
        if (en)
            q = d;
        // else q retains its value (latch behavior)
    end
endmodule

// Top module instantiating the latch primitive explicitly
module TopModule(
    input d,
    input ena,
    output q
);
    latch u_latch (
        .q(q),
        .d(d),
        .en(ena)
    );
endmodule