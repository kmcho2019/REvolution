module TopModule (
    input clk,
    input a,
    output reg q
);

// Combinational inversion followed by sequential registration
always @(posedge clk) begin
    q <= ~a;  // Invert 'a' combinationally, then register
end

endmodule