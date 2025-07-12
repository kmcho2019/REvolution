module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Combinational next state logic
wire [511:0] next_q;

// First bit (left neighbor is 0)
assign next_q[0] = 1'b0 ^ q[1];

// Middle bits (bits 1 through 510)
genvar i;
generate
    for (i = 1; i < 511; i = i + 1) begin: rule90_middle
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

// Last bit (right neighbor is 0)
assign next_q[511] = q[510] ^ 1'b0;

// Sequential update
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule