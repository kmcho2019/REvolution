module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // 6-bit counter (MSB is direction, lower 5 bits are value)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0_10000;  // Start at midpoint (16) with direction=0 (up)
        wave <= 5'b10000;
    end else begin
        // Update counter based on current direction (MSB)
        if (~counter[5]) begin
            // Increment mode
            counter <= (counter[4:0] == 5'b11111) ? 6'b1_11110 : counter + 1;
        end else begin
            // Decrement mode
            counter <= (counter[4:0] == 5'b00000) ? 6'b0_00001 : counter - 1;
        end
        
        // Output is always lower 5 bits
        wave <= counter[4:0];
    end
end

endmodule