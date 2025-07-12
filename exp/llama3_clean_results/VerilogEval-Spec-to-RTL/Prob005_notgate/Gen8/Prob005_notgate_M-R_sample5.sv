module TopModule(
    input  in,
    output reg out
);

// Using an always block for a procedural implementation
always @(*) begin
    out <= ~in; // Non-blocking assignment for updating output
end

endmodule