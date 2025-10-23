module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;
genvar i;
generate
    for (i = 0; i < 512; i = i + 1) begin : rule90
        if (i == 0) begin
            // Left boundary: neighbor is q[1], left is 0
            assign next_q[i] = 1'b0 ^ q[i+1];
        end
        else if (i == 511) begin
            // Right boundary: neighbor is q[510], right is 0
            assign next_q[i] = q[i-1] ^ 1'b0;
        end
        else begin
            // Internal cells: both neighbors exist
            assign next_q[i] = q[i-1] ^ q[i+1];
        end
    end
endgenerate

always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule