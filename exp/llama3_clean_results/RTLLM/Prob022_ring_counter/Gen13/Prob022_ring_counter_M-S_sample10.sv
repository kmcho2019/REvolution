module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0
        out <= 8'b0000_0001; // Directly set the initial output state
    end else begin
        // Increment the counter with each clock cycle, wrapping around if necessary
        counter <= (counter == 7)? 0 : counter + 1;
        
        // Use the counter to set the correct bit high in out
        case (counter)
            3'b000: out <= 8'b0000_0001;
            3'b001: out <= 8'b0000_0010;
            3'b010: out <= 8'b0000_0100;
            3'b011: out <= 8'b0000_1000;
            3'b100: out <= 8'b0001_0000;
            3'b101: out <= 8'b0010_0000;
            3'b110: out <= 8'b0100_0000;
            3'b111: out <= 8'b1000_0000;
        endcase
    end
end

endmodule