module TopModule (
    output zero
);
// Use an always block to drive the output port 'zero' with a constant LOW value
always @(zero) begin
    zero = 1'b0;
end
endmodule