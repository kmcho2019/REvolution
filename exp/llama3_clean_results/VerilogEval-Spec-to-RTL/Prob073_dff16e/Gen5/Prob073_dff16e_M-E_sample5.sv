module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// Generate a mask from byteena
reg [15:0] mask;

always @(*) begin
    case (byteena)
        2'b00: mask = 16'd0;
        2'b01: mask = 16'd255; // 0xFF, enabling the lower byte
        2'b10: mask = 16'd65280; // 0xFF00, enabling the upper byte
        2'b11: mask = 16'd65535; // 0xFFFF, enabling both bytes
    endcase
end

// Update q based on the mask
always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0;
    end else begin
        q <= (q & ~mask) | (d & mask);
    end
end

endmodule