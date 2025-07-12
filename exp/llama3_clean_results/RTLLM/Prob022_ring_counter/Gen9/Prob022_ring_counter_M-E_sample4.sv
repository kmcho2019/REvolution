module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 3'b000; // Reset the counter to 0
        out <= 8'b0000_0001; // Initialize out with the LSB set to 1
    end else begin
        // Increment the counter, wrapping around to 0 after 7
        if (counter == 3'b111) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        
        // Generate the output based on the counter's value
        case (counter)
            3'b000: out <= 8'b0000_0001; // LSB
            3'b001: out <= 8'b0000_0010;
            3'b010: out <= 8'b0000_0100;
            3'b011: out <= 8'b0000_1000;
            3'b100: out <= 8'b0001_0000;
            3'b101: out <= 8'b0010_0000;
            3'b110: out <= 8'b0100_0000;
            3'b111: out <= 8'b1000_0000; // MSB
        endcase
    end
end

endmodule