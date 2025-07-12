module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

// Combinational logic for Rule 90
assign next_q[0] = 1'b0 ^ q[1];  // Left boundary is 0
assign next_q[511] = q[510] ^ 1'b0;  // Right boundary is 0

genvar i;
for (i = 1; i < 511; i = i + 1) begin : rule90_core
    assign next_q[i] = q[i-1] ^ q[i+1];
end

// Sequential logic
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule