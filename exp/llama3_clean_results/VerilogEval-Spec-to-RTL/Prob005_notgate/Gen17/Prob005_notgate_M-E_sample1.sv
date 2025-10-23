// Module declaration for a NOT gate using an XOR gate
module TopModule(
    input  in,  // Input to the NOT gate
    output out   // Output of the NOT gate
);
    // Use an XOR gate with one input tied to '1' to invert the input
    assign out = in ^ 1'b1;
endmodule