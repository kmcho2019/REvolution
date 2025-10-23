module TopModule #(
    parameter ENABLE_VERIFICATION = 0
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // AND gate using assign statement (most efficient)
    assign out_assign = a & b;

    // AND gate using always block (direct assignment)
    always @(a or b) begin
        out_alwaysblock = a & b;
    end

    // Optional verification logic
    generate
        if (ENABLE_VERIFICATION) begin : verify
            wire verification_mismatch = (out_assign != out_alwaysblock);
            always @(posedge verification_mismatch) begin
                $display("Error: AND gate mismatch at time %t", $time);
            end
        end
    endgenerate
endmodule