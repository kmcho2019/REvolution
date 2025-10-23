module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;
genvar i;

generate
    for (i = 0; i < 512; i = i + 1) begin : rule90_cells
        assign next_q[i] = (i == 0) ? (0 ^ q[1]) :       // Left boundary
                         (i == 511) ? (q[510] ^ 0) :    // Right boundary
                         (q[i-1] ^ q[i+1]);             // Normal case
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