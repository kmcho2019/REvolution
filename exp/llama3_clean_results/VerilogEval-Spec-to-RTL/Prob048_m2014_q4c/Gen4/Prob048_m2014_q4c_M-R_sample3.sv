module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    q <= (r)? 0 : d; // Use ternary operator for conditional assignment
end

endmodule