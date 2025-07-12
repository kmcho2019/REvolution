module TopModule (
    output zero
);
// Use an always block to drive the output port 'zero'
always @(*) begin
    zero = 1'b0;
end
endmodule