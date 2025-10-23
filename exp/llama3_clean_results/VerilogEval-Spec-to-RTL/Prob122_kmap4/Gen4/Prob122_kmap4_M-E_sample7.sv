module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_match_00, ab_match_01, ab_match_10, ab_match_11;

    // Generate matches for ab patterns
    assign ab_match_00 = (a == 0 && b == 0);
    assign ab_match_01 = (a == 0 && b == 1);
    assign ab_match_10 = (a == 1 && b == 0);
    assign ab_match_11 = (a == 1 && b == 1);

    // Output logic based on cd and ab patterns
    assign out = ((c == 0 && d == 0 && (ab_match_01 || ab_match_10)) ||
                  (c == 0 && d == 1 && (ab_match_00 || ab_match_11)) ||
                  (c == 1 && d == 1 && (ab_match_01 || ab_match_10)) ||
                  (c == 1 && d == 0 && (ab_match_00 || ab_match_11)));

endmodule