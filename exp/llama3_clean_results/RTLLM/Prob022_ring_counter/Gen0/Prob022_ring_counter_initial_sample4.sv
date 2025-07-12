module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

integer i;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        // Initialize the output to its starting state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Shift the set bit to the next position on each rising edge of the clock signal
        for(i = 0; i < 8; i++) begin
            if(out[i] == 1'b1) begin
                // Shift the 1 to the next bit, wrapping around to the start if necessary
                if(i == 7) begin
                    out <= 8'b0000_0001; // Wrap around to the LSB
                end else begin
                    out <= (1 << (i + 1)); // Shift the 1 to the next bit
                end
                break; // Exit the loop once the set bit is found and shifted
            end
        end
    end
end

endmodule