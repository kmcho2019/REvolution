module AndVerifier (
    input a,
    input b,
    input assign_out,
    input always_out,
    output reg mismatch
);
    always @(*) begin
        mismatch = (assign_out != always_out);
        if (mismatch) $display("Error: AND gate mismatch at time %t", $time);
    end
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Direct implementation using assign statement
    assign out_assign = a & b;
    
    // Direct implementation using always block
    reg out_always;
    always @(*) out_always = a & b;
    assign out_alwaysblock = out_always;

    // Optional verification (uncomment when needed)
    // wire mismatch;
    // AndVerifier verifier (
    //     .a(a),
    //     .b(b),
    //     .assign_out(out_assign),
    //     .always_out(out_alwaysblock),
    //     .mismatch(mismatch)
    // );
endmodule