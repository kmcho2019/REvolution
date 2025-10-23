module TopModule #(
    parameter ENABLE_VERIFICATION = 0
) (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct implementation using assign statement
    assign out_assign = a & b;
    
    // Direct implementation using always block
    always @(*) out_alwaysblock = a & b;

    // Optional verification
    generate
        if (ENABLE_VERIFICATION) begin : verify
            wire mismatch;
            always @(*) begin
                mismatch = (out_assign != out_alwaysblock);
                if (mismatch) 
                    $display("Error: AND gate mismatch at time %t", $time);
            end
        end
    endgenerate
endmodule