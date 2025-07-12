module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // Counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0 when reset is high
    end else begin
        // Increment the counter and wrap around to 0 when it reaches 7
        counter <= (counter == 7)? 0 : counter + 1;
    end
end

always @(*) begin
    case (counter)
        3'b000: out = 8'b0000_0001;
        3'b001: out = 8'b0000_0010;
        3'b010: out = 8'b0000_0100;
        3'b011: out = 8'b0000_1000;
        3'b100: out = 8'b0001_0000;
        3'b101: out = 8'b0010_0000;
        3'b110: out = 8'b0100_0000;
        3'b111: out = 8'b1000_0000;
        default: out = 8'b0000_0001;
    endcase
end

endmodule