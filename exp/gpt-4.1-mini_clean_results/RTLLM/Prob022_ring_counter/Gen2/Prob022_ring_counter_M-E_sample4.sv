module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

wire [7:0] rotated_out;

// Rotate left by 1 bit: MSB goes to LSB, others shift left by one
assign rotated_out = {out[6:0], out[7]};

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000001;
    end else begin
        out <= rotated_out;
    end
end

endmodule