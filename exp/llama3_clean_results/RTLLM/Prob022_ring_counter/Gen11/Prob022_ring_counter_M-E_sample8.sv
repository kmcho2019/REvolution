module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 3'b000; // Initialize counter to 0
    end else begin
        if (count == 3'b111) begin // Wrap around to 0 when count reaches 7
            count <= 3'b000;
        end else begin
            count <= count + 1'b1; // Increment counter
        end
    end
end

always @(*) begin
    case (count)
        3'b000: out = 8'b0000_0001; // Set LSB to 1
        3'b001: out = 8'b0000_0010; // Set second bit to 1
        3'b010: out = 8'b0000_0100; // Set third bit to 1
        3'b011: out = 8'b0000_1000; // Set fourth bit to 1
        3'b100: out = 8'b0001_0000; // Set fifth bit to 1
        3'b101: out = 8'b0010_0000; // Set sixth bit to 1
        3'b110: out = 8'b0100_0000; // Set seventh bit to 1
        3'b111: out = 8'b1000_0000; // Set MSB to 1
    endcase
end

endmodule