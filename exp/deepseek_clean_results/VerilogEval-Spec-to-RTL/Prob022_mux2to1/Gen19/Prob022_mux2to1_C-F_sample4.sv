module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // Optimal implementation using ternary operator
    assign out = sel ? b : a;

    // Verification assertion covering all cases
    always @(*) begin
        if (sel === 0) assert(out === a);
        if (sel === 1) assert(out === b);
    end
endmodule