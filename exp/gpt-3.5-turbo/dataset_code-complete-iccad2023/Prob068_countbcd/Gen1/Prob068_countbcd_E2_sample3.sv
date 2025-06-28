module TopModule (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [3:0] counter[3:0]; // Array to store individual counter values for each digit

always @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < 4; i = i + 1) begin
            counter[i] <= 4'b0000; // Reset all counter values to 0
        end
    end else begin
        counter[0] <= (counter[0] == 4'b1001) ? 4'b0000 : counter[0] + 1; // Increment ones digit on every clock cycle
        
        for (int i = 1; i < 4; i = i + 1) begin
            if (ena[i]) // Check enable signal for the digit
                counter[i] <= (counter[i] == 4'b1001) ? 4'b0000 : counter[i] + 1; // Increment the digit if enable is high
        end
    end
end

// Assign the counter values to the output signal q
assign q = {counter[3], counter[2], counter[1], counter[0]};

endmodule