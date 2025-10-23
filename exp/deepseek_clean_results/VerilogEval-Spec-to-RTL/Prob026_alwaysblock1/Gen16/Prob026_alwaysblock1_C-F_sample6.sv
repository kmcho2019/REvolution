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
    parameter VERIFY = 0  // Enable verification in simulation
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Instantiate both implementations
    AndAssign u_assign (.a(a), .b(b), .out(out_assign));
    AndAlways u_always (.a(a), .b(b), .out(out_alwaysblock));

    // Verification logic (active in simulation only)
    generate
        if (VERIFY) begin
            always @(*) begin
                if (out_assign != out_alwaysblock) begin
                    $display("Error: AND gate mismatch at time %t", $time);
                    $display("  Inputs: a=%b, b=%b", a, b);
                    $display("  Assign output: %b", out_assign);
                    $display("  Always output: %b", out_alwaysblock);
                end
            end
        end
    endgenerate
endmodule