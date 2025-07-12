module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

// Combinational logic for next state
assign next_q[0] = 0 ^ q[1];               // Left boundary
assign next_q[511] = q[510] ^ 0;           // Right boundary

genvar i;
generate
    for (i = 1; i < 511; i = i + 1) begin : rule90
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

// Sequential logic for state update
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule