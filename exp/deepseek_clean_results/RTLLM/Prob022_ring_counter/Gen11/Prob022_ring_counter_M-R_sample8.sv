module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [2:0] pos_counter;

// Counter logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos_counter <= 3'b000;
    end
    else begin
        pos_counter <= pos_counter + 1;
    end
end

// One-hot decoder
assign out = (pos_counter == 3'b000) ? 8'b00000001 :
             (pos_counter == 3'b001) ? 8'b00000010 :
             (pos_counter == 3'b010) ? 8'b00000100 :
             (pos_counter == 3'b011) ? 8'b00001000 :
             (pos_counter == 3'b100) ? 8'b00010000 :
             (pos_counter == 3'b101) ? 8'b00100000 :
             (pos_counter == 3'b110) ? 8'b01000000 :
             8'b10000000;

endmodule