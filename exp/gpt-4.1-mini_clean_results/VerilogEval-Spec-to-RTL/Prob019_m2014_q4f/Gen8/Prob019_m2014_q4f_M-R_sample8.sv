module TopModule (
    input  in1,
    input  in2,
    output reg out
);

// Implement out = in1 AND (NOT in2) using an always_comb procedural block
// This models an AND gate with a bubble on the in2 input
always @(*) begin
    out = in1 & ~in2;
end

endmodule