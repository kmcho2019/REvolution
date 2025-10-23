module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state (0 to 7)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset counter to 0 when reset is high
    end else begin
        counter <= counter + 1; // Increment counter on each clock pulse
        if (counter == 8) begin
            counter <= 0; // Wrap counter around to 0 after reaching 7
        end
    end
end

// Use the counter value to set the corresponding bit high in the output
always @(*) begin
    case (counter)
        0: out = 8'b0000_0001;
        1: out = 8'b0000_0010;
        2: out = 8'b0000_0100;
        3: out = 8'b0000_1000;
        4: out = 8'b0001_0000;
        5: out = 8'b0010_0000;
        6: out = 8'b0100_0000;
        7: out = 8'b1000_0000;
    endcase
end

endmodule