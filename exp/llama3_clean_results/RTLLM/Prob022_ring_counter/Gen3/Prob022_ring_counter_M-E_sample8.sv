module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] temp_out;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        temp_out <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Perform a cyclic shift by moving the MSB to the LSB position
        temp_out <= {temp_out[6:0], temp_out[7]}; // Cyclic shift operation
    end
end

assign out = temp_out;

endmodule