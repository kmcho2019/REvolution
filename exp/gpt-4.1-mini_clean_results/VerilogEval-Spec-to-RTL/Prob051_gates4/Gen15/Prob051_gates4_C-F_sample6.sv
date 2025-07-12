module FourInputGate #(
    parameter GATETYPE = "AND",
    parameter USE_TREE = 1  // 1: use explicit 2-input gate tree; 0: use reduction operator
) (
    input  [3:0] in,
    output       out
);
    generate
        if (USE_TREE) begin
            // Explicit balanced 2-input gate tree implementation
            wire level1_0, level1_1;
            if (GATETYPE == "AND") begin
                and u0(level1_0, in[0], in[1]);
                and u1(level1_1, in[2], in[3]);
                and u2(out,     level1_0, level1_1);
            end else if (GATETYPE == "OR") begin
                or  u0(level1_0, in[0], in[1]);
                or  u1(level1_1, in[2], in[3]);
                or  u2(out,     level1_0, level1_1);
            end else if (GATETYPE == "XOR") begin
                xor u0(level1_0, in[0], in[1]);
                xor u1(level1_1, in[2], in[3]);
                xor u2(out,     level1_0, level1_1);
            end else begin
                assign out = 1'b0;
            end
        end else begin
            // Use built-in reduction operator for succinctness
            if (GATETYPE == "AND") begin
                assign out = &in;
            end else if (GATETYPE == "OR") begin
                assign out = |in;
            end else if (GATETYPE == "XOR") begin
                assign out = ^in;
            end else begin
                assign out = 1'b0;
            end
        end
    endgenerate
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Instantiate with explicit gate tree for clarity and potential synthesis guidance
    FourInputGate #(.GATETYPE("AND"), .USE_TREE(1)) u_and (.in(in), .out(out_and));
    FourInputGate #(.GATETYPE("OR"),  .USE_TREE(1)) u_or  (.in(in), .out(out_or));
    FourInputGate #(.GATETYPE("XOR"), .USE_TREE(1)) u_xor (.in(in), .out(out_xor));
endmodule