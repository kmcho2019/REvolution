module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Left neighbor: q shifted left by 1 bit, leftmost bit is 0
            // Right neighbor: q shifted right by 1 bit, rightmost bit is 0
            q <= (q << 1) ^ (q >> 1);
        end
    end

endmodule