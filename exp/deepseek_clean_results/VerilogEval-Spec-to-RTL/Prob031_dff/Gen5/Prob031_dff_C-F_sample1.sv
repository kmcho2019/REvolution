module TopModule (
    input clk,
    input d,
    output reg q
);

// Positive edge-triggered D flip-flop
always @(posedge clk) begin
    q <= d;
end

endmodule