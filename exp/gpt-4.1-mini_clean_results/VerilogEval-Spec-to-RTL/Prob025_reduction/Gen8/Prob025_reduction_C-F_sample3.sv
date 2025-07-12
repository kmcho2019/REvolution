module TopModule (
    input  [7:0] in,
    output reg   parity
);
    // Compute even parity by XOR'ing all bits of the input vector.
    // Use the Verilog reduction XOR operator (^) inside a combinational always block.
    // This combines clarity of explicit combinational logic with the synthesis efficiency
    // of a balanced XOR tree, ensuring minimal delay, area, and power.
    always @(*) begin
        parity = ^in;
    end
endmodule