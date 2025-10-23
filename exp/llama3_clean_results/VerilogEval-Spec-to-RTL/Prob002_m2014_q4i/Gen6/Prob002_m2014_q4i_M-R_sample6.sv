module TopModule(
    output out
);

// Using an always block to define a combinational logic
// that outputs a constant value
always @(*) begin
    out = 1'b0;
end

endmodule