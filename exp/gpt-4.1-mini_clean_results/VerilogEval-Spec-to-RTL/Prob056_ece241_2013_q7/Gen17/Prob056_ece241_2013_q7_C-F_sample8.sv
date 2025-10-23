module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

wire Q_next;

// Explicit JK flip-flop next state logic as per truth table
assign Q_next = (j & ~k)      ? 1'b1   : // J=1, K=0 --> Q=1
                (~j & k)      ? 1'b0   : // J=0, K=1 --> Q=0
                (j & k)       ? ~Q     : // J=1, K=1 --> Q toggles
                                Q;      // J=0, K=0 --> Q holds

always @(posedge clk) begin
    Q <= Q_next;
end

endmodule