module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
wire [WIDTH-1:0] next_q;

// Boundary conditions (q[-1] and q[512] are both 0)
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        wire left_neighbor = (i == 0) ? left_boundary : q[i-1];
        wire right_neighbor = (i == WIDTH-1) ? right_boundary : q[i+1];
        assign next_q[i] = left_neighbor ^ right_neighbor;
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