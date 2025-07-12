module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000;
        out <= 8'b00000001;
    end
    else begin
        counter <= counter + 1;
        case (counter)
            3'b000: out <= 8'b00000001;
            3'b001: out <= 8'b00000010;
            3'b010: out <= 8'b00000100;
            3'b011: out <= 8'b00001000;
            3'b100: out <= 8'b00010000;
            3'b101: out <= 8'b00100000;
            3'b110: out <= 8'b01000000;
            3'b111: out <= 8'b10000000;
        endcase
    end
end

endmodule