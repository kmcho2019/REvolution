module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    q <= (r)? 1'b0 : d; // Using ternary operator to simulate MUX behavior
end

endmodule