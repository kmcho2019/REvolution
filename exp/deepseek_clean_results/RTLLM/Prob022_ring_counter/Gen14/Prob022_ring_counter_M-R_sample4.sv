module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [2:0] pos;  // Position counter (0-7)

// Position counter logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 3'b000;
    end
    else begin
        pos <= (pos == 3'b111) ? 3'b000 : pos + 1;
    end
end

// One-hot decoder
assign out = (pos == 3'b000) ? 8'b00000001 :
             (pos == 3'b001) ? 8'b00000010 :
             (pos == 3'b010) ? 8'b00000100 :
             (pos == 3'b011) ? 8'b00001000 :
             (pos == 3'b100) ? 8'b00010000 :
             (pos == 3'b101) ? 8'b00100000 :
             (pos == 3'b110) ? 8'b01000000 :
             8'b10000000;

endmodule