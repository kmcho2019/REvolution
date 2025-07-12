module TopModule (
    input clk,
    input a,
    output reg q
);

wire next_q;
assign next_q = ~a;  // Explicit combinational logic

always @(posedge clk) begin
    q <= next_q;     // Clear sequential assignment
end

endmodule