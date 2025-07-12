module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire wrap_condition = q[3] & q[1];  // Check for 10 (8+2)

assign next_q = reset ? 4'b0001 :       // Reset condition
                wrap_condition ? 4'b0001 :  // Wrap condition
                q + 1;                  // Normal increment

always @(posedge clk) begin
    q <= next_q;  // Sequential update
end

endmodule