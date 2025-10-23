// Module declaration for a NOT gate using an XOR gate
module TopModule(
    input  in,  // Input to the NOT gate
    output reg out   // Output of the NOT gate
);
    // Use an always block for procedural assignment
    always @(*) begin
        // Use an XOR gate with one input tied to '1' to invert the input
        out = in ^ 1'b1;
    end
endmodule