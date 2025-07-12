module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

// Optimized combinational logic
assign next_q = a ? 3'd4 :            // When a=1, output is 4
                (q[2] & q[1]) ? 3'd0 : // When q=6 (110) or 7 (111), wrap to 0
                q + 1'b1;              // Otherwise increment

// Sequential element with clock gating
always @(posedge clk) begin
    q <= next_q;
end

endmodule