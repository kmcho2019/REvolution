module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001; // Initialize to starting state when reset is high
        end else begin
            // Cyclic state transition logic
            if (out == 8'b1000_0000) begin // Check if at MSB
                out <= 8'b0000_0001; // Wrap around to LSB
            end else begin
                // Shift '1' to the next bit
                out <= {out[6:0], out[7]}; 
            end
        end
    end

endmodule