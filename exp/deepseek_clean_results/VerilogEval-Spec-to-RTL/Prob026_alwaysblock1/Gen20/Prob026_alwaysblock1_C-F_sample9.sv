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
    output out
);
    reg out_reg;
    always @(*) out_reg = a & b;
    assign out = out_reg;
endmodule

module TopModule #(
    parameter SIM_VERIFY = 0  // Enable simulation verification
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Instantiate both implementations
    AndAssign u_assign (.a(a), .b(b), .out(out_assign));
    AndAlways u_always (.a(a), .b(b), .out(out_alwaysblock));

    // Comprehensive verification logic (simulation only)
    generate
        if (SIM_VERIFY) begin : verification
            wire expected = a & b;
            always @(*) begin
                if (out_assign !== expected || out_alwaysblock !== expected) begin
                    $error("[%0t] AND gate verification failed!", $time);
                    $display("  Inputs: a=%b, b=%b", a, b);
                    $display("  Expected: %b", expected);
                    $display("  Assign output: %b", out_assign);
                    $display("  Always output: %b", out_alwaysblock);
                end
            end
        end
    endgenerate
endmodule