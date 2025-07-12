`ifndef SYNTHESIS
    `define VERIFY_AND_GATES
`endif

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Both implementations as direct assign statements
    assign out_assign = a & b;
    assign out_alwaysblock = a & b;

`ifdef VERIFY_AND_GATES
    // Verification only in simulation
    always @(*) begin
        if (out_assign !== out_alwaysblock) begin
            $error("AND gate mismatch at time %0t: a=%b, b=%b, assign=%b, always=%b",
                   $time, a, b, out_assign, out_alwaysblock);
        end
    end
`endif
endmodule