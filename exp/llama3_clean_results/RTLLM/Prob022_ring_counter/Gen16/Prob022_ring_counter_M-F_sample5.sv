module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] counter; // 3-bit counter to keep track of the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0; // Reset the counter to 0
        out <= 8'b0000_0001; // Initialize output to the starting state
    end else begin
        // Increment the counter with each clock cycle, wrapping around if necessary
        counter <= (counter == 7)? 0 : counter + 1;
        
        // Use a case statement to generate the output based on the counter's current value
        case (counter)
            0: out <= 8'b0000_0001;
            1: out <= 8'b0000_0010;
            2: out <= 8'b0000_0100;
            3: out <= 8'b0000_1000;
            4: out <= 8'b0001_0000;
            5: out <= 8'b0010_0000;
            6: out <= 8'b0100_0000;
            7: out <= 8'b1000_0000;
        endcase
    end
end

endmodule