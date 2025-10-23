module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Implementing the simplified logic using essential prime implicants
    always @(*) begin
        out = (a == 0 && b == 0 && c == 1) ||
              (a == 0 && b == 1 && c == 1 && d == 0) ||
              (a == 1 && b == 0 && c == 1 && d == 0) ||
              (a == 0 && b == 1 && c == 1) ||
              (a == 1 && b == 0 && c == 1 && d == 1);
    end

endmodule