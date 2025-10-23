module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

// Boundary conditions
assign next_q[0] = 0 ^ q[1];         // Left neighbor is 0
assign next_q[511] = q[510] ^ 0;     // Right neighbor is 0

// Middle cells
genvar i;
generate
    for (i = 1; i < 511; i = i + 1) begin : middle_cells
        assign next_q[i] = q[i-1] ^ q[i+1];
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule