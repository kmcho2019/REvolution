module AndAssign (
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module AndAlways (
    input a,
    input b,
    output reg out
);
    always @(*) out = a & b;
endmodule

module TopModule #(
    parameter VERIFY = 0  // Default to no verification
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Instantiate both implementations
    AndAssign u_assign (.a(a), .b(b), .out(out_assign));
    AndAlways u_always (.a(a), .b(b), .out(out_alwaysblock));

    // Single verification block for both implementations
    generate
        if (VERIFY) begin
            always @(*) begin
                if (out_assign !== out_alwaysblock) begin
                    $error("AND gate mismatch at time %0t: a=%b, b=%b, assign=%b, always=%b",
                           $time, a, b, out_assign, out_alwaysblock);
                end
            end
        end
    endgenerate
endmodule