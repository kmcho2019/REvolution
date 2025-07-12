module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Generate mask directly using assign and bitwise operators
wire [15:0] mask;
assign mask = (byteena[0] ? 16'd255 : 16'd0) | (byteena[1] ? 16'd65280 : 16'd0);

// Update q based on the mask
always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0;
    end else begin
        q <= (q & ~mask) | (d & mask);
    end
end

endmodule