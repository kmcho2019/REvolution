module TopModule (
    input clk,
    input d,
    output reg q
);

wire next_q;

assign next_q = d;

always @(posedge clk) begin
    q <= next_q;
end

endmodule