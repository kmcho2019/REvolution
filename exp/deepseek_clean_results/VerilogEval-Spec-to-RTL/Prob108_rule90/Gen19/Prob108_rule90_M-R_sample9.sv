module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;

// Next state computation with embedded boundary conditions
wire [WIDTH-1:0] next_q;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        assign next_q[i] = (i == 0 ? 1'b0 : q[i-1]) ^ (i == WIDTH-1 ? 1'b0 : q[i+1]);
    end
endgenerate

// State update with load functionality
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule