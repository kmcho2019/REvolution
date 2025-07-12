module TopModule(
    input [99:0] a,  // 100-bit input a
    input [99:0] b,  // 100-bit input b
    input sel,      // 1-bit select line
    output [99:0] out  // 100-bit output
);

    // Using ternary operator for conditional assignment
    assign out = (sel == 1'b0) ? a : b;

    // Alternatively, you could use an if-else statement in a procedural block
    // always @(*) begin
    //     if (sel == 1'b0) out <= a;
    //     else out <= b;
    // end

endmodule