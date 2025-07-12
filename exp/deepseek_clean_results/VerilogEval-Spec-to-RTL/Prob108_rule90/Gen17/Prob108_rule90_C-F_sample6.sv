module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
wire [WIDTH-1:0] next_q;

// Explicit boundary conditions (q[-1] and q[512] are both 0)
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

// Combinational Rule 90 logic
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        wire left = (i == 0) ? left_boundary : q[i-1];
        wire right = (i == WIDTH-1) ? right_boundary : q[i+1];
        assign next_q[i] = left ^ right;
    end
endgenerate

// Synchronous update with potential for clock gating
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule