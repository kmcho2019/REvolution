module TopModule (
    input a,       // Don't-care input
    input b,       // Primary input
    input c,       // Primary input
    input d,       // Don't-care input
    output reg q   // Now declared as reg for procedural assignment
);

    // Using always block instead of continuous assignment
    always @(b or c) begin
        q = b | c;
    end

endmodule