module TopModule (
    input clk,
    input a,
    output reg q
);

wire d;
assign d = ~a;  // Combinational logic

always @(posedge clk) begin
    q <= d;      // Sequential element
end

endmodule