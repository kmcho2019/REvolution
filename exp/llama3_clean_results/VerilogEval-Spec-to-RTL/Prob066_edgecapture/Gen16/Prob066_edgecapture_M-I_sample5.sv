module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Update prev_in before checking for transitions to ensure it holds the previous value
        prev_in <= in;
        
        // Iterate through each bit of the input to check for transitions
        for (int i = 0; i < 32; i++) begin
            // If the previous value of the bit was 1 and the current value is 0, set the output bit
            if (prev_in[i] == 1 && in[i] == 0) begin
                out[i] <= 1'b1; // Set the output bit if transition is detected
            end
        end
    end
end

endmodule