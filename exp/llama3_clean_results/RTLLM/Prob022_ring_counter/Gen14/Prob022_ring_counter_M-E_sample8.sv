module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset counter to 0
        counter <= 3'd0;
    end else begin
        // Increment counter, wrapping around to 0 after reaching 7
        counter <= (counter == 3'd7) ? 3'd0 : counter + 1'd1;
    end
end

always @(*) begin
    // Decoder: Set the bit corresponding to the counter value high, all others low
    case (counter)
        3'd0: out = 8'b0000_0001;
        3'd1: out = 8'b0000_0010;
        3'd2: out = 8'b0000_0100;
        3'd3: out = 8'b0000_1000;
        3'd4: out = 8'b0001_0000;
        3'd5: out = 8'b0010_0000;
        3'd6: out = 8'b0100_0000;
        3'd7: out = 8'b1000_0000;
    endcase
end

endmodule