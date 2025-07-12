module TopModule (
    input clk,
    input a,
    output reg q
);

wire d_inv;
assign d_inv = ~a;  // Explicit combinational logic

always @(posedge clk) begin
    q <= d_inv;     // Clear sequential element
end

endmodule