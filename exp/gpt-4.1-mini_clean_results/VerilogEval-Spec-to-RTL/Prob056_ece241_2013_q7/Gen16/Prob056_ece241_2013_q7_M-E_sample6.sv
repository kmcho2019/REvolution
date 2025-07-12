module TopModule (
    input wire clk,
    input wire j,
    input wire k,
    output reg Q
);

wire next_state;

assign next_state = (j & ~Q) | (~k & Q);

always @(posedge clk) begin
    Q <= next_state;
end

endmodule