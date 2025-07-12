module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;

wire [WIDTH-1:0] next_q;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        wire left = (i == 0) ? 1'b0 : q[i-1];
        wire right = (i == WIDTH-1) ? 1'b0 : q[i+1];
        assign next_q[i] = left ^ right;
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