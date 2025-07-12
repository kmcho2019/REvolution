module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialize q
initial q = 1'b1;

// Update q on the positive edge of the clock
always @(posedge clk) begin
    q <= ~a;
end

endmodule