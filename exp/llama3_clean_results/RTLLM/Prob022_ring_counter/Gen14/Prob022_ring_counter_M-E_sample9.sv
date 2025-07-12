module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Reset counter to 0 when reset is high
    end else begin
        if (counter == 3'b111) begin // If counter reaches 7, wrap around to 0
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1; // Otherwise, increment the counter
        end
    end
end

always @(*) begin
    case (counter)
        3'b000: out = 8'b0000_0001; // Set the corresponding bit to '1' based on the counter value
        3'b001: out = 8'b0000_0010;
        3'b010: out = 8'b0000_0100;
        3'b011: out = 8'b0000_1000;
        3'b100: out = 8'b0001_0000;
        3'b101: out = 8'b0010_0000;
        3'b110: out = 8'b0100_0000;
        3'b111: out = 8'b1000_0000;
    endcase
end

endmodule