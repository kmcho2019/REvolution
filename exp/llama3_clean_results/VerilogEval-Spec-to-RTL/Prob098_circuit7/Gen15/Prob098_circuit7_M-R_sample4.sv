module TopModule(
    input clk,
    input a,
    output reg q
);

initial q = 1'b1;

// Simple inversion of 'a' on the rising edge of the clock
always @(posedge clk) begin
    q <= ~a; // Direct inversion on the rising edge
end

endmodule