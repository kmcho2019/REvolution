// Refactored Module TopModule using an always block for combinational logic
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);

// Use an always block with a sensitivity list to update out based on in
always @(*) begin
    out = in;  // Procedural assignment of in to out
end

endmodule