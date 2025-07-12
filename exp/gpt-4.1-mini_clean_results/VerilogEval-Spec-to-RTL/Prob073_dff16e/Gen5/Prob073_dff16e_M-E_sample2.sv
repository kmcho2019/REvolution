module TopModule (
    input        clk,
    input        resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output reg [15:0] q
);

wire [15:0] byte_mask;
wire [15:0] new_data;

// Create byte masks: 0xFF00 if byteena[1] set, 0x00FF if byteena[0] set
assign byte_mask = { {8{byteena[1]}}, {8{byteena[0]}} };

// Selectively combine old q and new d using the mask
assign new_data = (q & ~byte_mask) | (d & byte_mask);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        q <= new_data;
    end
end

endmodule