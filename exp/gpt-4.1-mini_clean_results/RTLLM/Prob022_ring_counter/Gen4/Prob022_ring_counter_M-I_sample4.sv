module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

wire [7:0] rotated_out;
assign rotated_out = {out[6:0], out[7]};

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize with LSB set
    end else begin
        out <= rotated_out;
    end
end

endmodule