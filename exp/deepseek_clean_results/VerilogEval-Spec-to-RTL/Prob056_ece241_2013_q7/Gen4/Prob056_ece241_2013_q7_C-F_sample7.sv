module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire next_state;

assign next_state = (j & ~k) | (~k & Q) | (j & Q);

always @(posedge clk) begin
    Q <= next_state;
end

endmodule