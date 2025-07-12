module TopModule (
    output one
);
// Use an always block to drive the output 'one' high
always @(*) begin
    one = 1'b1;
end

endmodule