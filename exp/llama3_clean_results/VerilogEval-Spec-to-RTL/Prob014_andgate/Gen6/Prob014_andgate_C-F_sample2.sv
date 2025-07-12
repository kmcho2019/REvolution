// Module declaration for a 2-input AND gate
module TopModule(
    // Input signals
    input  a,
    input  b,
    // Output signal
    output reg out
);

// Always block to implement combinational logic
// The sensitivity list (@(*)) includes all input signals
always @(*) begin
    // Implement the AND gate logic
    out = a & b;
end

endmodule