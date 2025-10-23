module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

// Next state logic
wire next_state;
assign next_state = (j & k) ? ~Q :   // Toggle when both 1
                    (j & ~k) ? 1'b1 : // Set when J=1,K=0
                    (~j & k) ? 1'b0 : // Reset when J=0,K=1
                    Q;                // Hold otherwise

// State transition
always @(posedge clk) begin
    Q <= next_state;
end

endmodule