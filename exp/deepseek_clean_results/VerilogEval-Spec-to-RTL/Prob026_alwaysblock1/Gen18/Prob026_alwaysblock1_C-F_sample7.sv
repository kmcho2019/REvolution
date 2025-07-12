module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;

    // AND gate using always block
    always @(*) out_alwaysblock = a & b;

`ifdef VERIFICATION
    // Verification logic (active only in simulation)
    wire verification_mismatch = (out_assign != out_alwaysblock);
    always @(verification_mismatch) begin
        if (verification_mismatch)
            $display("Error: AND gate mismatch at time %t", $time);
    end
`endif
endmodule