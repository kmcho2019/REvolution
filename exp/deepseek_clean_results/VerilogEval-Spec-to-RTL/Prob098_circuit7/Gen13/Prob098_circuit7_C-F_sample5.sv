module TopModule (
    input clk,
    input a,
    output reg q
);

// Combinational logic is inline with sequential block
always @(posedge clk) begin
    q <= ~a;  // Invert and register in one step
end

endmodule