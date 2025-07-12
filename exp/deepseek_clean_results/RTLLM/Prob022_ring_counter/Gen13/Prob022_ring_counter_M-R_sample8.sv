module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [2:0] state;  // 3-bit state counter (0-7)

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= state + 1;  // Automatically wraps around
    end
end

// Output decoder (one-hot)
assign out = (state == 3'b000) ? 8'b00000001 :
             (state == 3'b001) ? 8'b00000010 :
             (state == 3'b010) ? 8'b00000100 :
             (state == 3'b011) ? 8'b00001000 :
             (state == 3'b100) ? 8'b00010000 :
             (state == 3'b101) ? 8'b00100000 :
             (state == 3'b110) ? 8'b01000000 :
                                 8'b10000000;

endmodule