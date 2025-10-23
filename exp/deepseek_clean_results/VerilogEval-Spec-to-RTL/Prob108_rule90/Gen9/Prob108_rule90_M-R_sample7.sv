module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Next state computation with continuous assignments
wire [511:0] next_q;

// Left boundary case (q[-1] = 0)
assign next_q[0] = 1'b0 ^ q[1];

// Right boundary case (q[512] = 0)
assign next_q[511] = q[510] ^ 1'b0;

// Middle cases
genvar i;
generate
    for (i = 1; i < 511; i = i + 1) begin : rule90
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

// Sequential update
always @(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= next_q;
end

endmodule