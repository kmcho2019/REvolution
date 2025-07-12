module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [2:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 3'b000;
    end else begin
        count <= count + 1;
    end
end

assign out = (count == 3'b000) ? 8'b00000001 :
             (count == 3'b001) ? 8'b00000010 :
             (count == 3'b010) ? 8'b00000100 :
             (count == 3'b011) ? 8'b00001000 :
             (count == 3'b100) ? 8'b00010000 :
             (count == 3'b101) ? 8'b00100000 :
             (count == 3'b110) ? 8'b01000000 :
             (count == 3'b111) ? 8'b10000000 :
             8'b00000001;

endmodule