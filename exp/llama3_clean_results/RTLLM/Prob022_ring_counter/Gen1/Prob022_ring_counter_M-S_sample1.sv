module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] temp;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Perform a cyclic shift by checking the position of the 1 in 'out' and moving it to the next position
        temp = 8'b0;
        for (int i = 0; i < 8; i++) begin
            if (out[i]) begin
                temp[(i + 1) % 8] = 1'b1; // Shift to the next bit and wrap around if necessary
            end
        end
        out <= temp;
    end
end

endmodule