module TopModule (
    input           clk,
    input           resetn,
    input   [1:0]   byteena,
    input   [15:0]  d,
    output  reg [15:0] q
);

// Generate gated clocks per byte
wire clk_upper = clk & byteena[1];
wire clk_lower = clk & byteena[0];

// Upper byte flip-flops with synchronous reset
always @(posedge clk_upper) begin
    if (!resetn)
        q[15:8] <= 8'b0;
    else
        q[15:8] <= d[15:8];
end

// Lower byte flip-flops with synchronous reset
always @(posedge clk_lower) begin
    if (!resetn)
        q[7:0] <= 8'b0;
    else
        q[7:0] <= d[7:0];
end

endmodule