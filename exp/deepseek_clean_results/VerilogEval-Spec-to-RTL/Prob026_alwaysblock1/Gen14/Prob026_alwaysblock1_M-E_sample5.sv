module SmartAnd #(
    parameter IMPLEMENTATION = 0,  // 0 for assign, 1 for always
    parameter VERIFY = 0           // Enable verification in simulation
) (
    input a,
    input b,
    output reg out,
    output reg mismatch = 0
);
    // Both implementations exist internally
    wire assign_out = a & b;
    reg always_out;
    always @(*) always_out = a & b;

    // Select implementation based on parameter
    generate
        if (IMPLEMENTATION == 0) begin
            always @(*) out = assign_out;
        end else begin
            always @(*) out = always_out;
        end
    endgenerate

    // Verification logic (active in simulation only)
    generate
        if (VERIFY) begin
            always @(*) begin
                mismatch = (assign_out != always_out);
                if (mismatch) $display("Error: AND gate mismatch at time %t", $time);
            end
        end
    endgenerate
endmodule

module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Instance using assign statement
    SmartAnd #(.IMPLEMENTATION(0)) u_assign (
        .a(a),
        .b(b),
        .out(out_assign),
        .mismatch()  // unused
    );

    // Instance using always block
    SmartAnd #(.IMPLEMENTATION(1)) u_always (
        .a(a),
        .b(b),
        .out(out_alwaysblock),
        .mismatch()  // unused
    );
endmodule