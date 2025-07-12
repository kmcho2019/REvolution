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
        temp = out;
        out <= {temp[6:0], temp[7]}; // Shift the bits to the right and wrap the MSB to the LSB
    end
end

endmodule