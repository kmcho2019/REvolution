`ifdef VERIFICATION
    wire verification_mismatch;
    assign verification_mismatch = (out_assign != out_alwaysblock);
`endif

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement
    assign out_assign = a & b;

    // AND gate using always block
    reg out_always_reg;
    always @(*) begin
        out_always_reg = a & b;
    end
    assign out_alwaysblock = out_always_reg;

`ifdef VERIFICATION
    initial begin
        forever begin
            @(posedge verification_mismatch);
            $display("Error: AND gate mismatch at time %t", $time);
        end
    end
`endif
endmodule