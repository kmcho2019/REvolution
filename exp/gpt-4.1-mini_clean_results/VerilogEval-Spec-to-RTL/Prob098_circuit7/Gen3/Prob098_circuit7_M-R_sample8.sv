module TopModule (
    input clk,
    input a,
    output reg q
);

wire next_q;
assign next_q = ~a;

always @(posedge clk) begin
    q <= next_q;
end

endmodule