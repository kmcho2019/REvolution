module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Truth table implementation using optimal mux structure:
    // When x3=0: f follows x2 (rows 1-4)
    // When x3=1: f follows x1 (rows 5-8)
    assign f = x3 ? x1 : x2;
endmodule