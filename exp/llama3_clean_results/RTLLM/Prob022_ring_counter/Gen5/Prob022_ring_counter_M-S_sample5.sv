module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        reg [7:0] temp;
        temp = 8'b0; // Initialize temp to all zeros
        for (int i = 0; i < 8; i++) begin
            if (out[i]) begin
                if (i == 7) begin
                    temp[0] = 1'b1; // Wrap around to the LSB
                end else begin
                    temp[i + 1] = 1'b1; // Shift the 1 to the next bit
                end
            end
        end
        out <= temp; // Assign the shifted value to out
    end
end

endmodule