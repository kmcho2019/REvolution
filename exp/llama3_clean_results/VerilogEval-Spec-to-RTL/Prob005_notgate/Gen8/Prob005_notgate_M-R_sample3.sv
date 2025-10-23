module TopModule(
    input  in,
    output out
);

// Using an always block for a simple NOT gate, though less conventional
always @(*) begin
    out = ~in;
end

endmodule