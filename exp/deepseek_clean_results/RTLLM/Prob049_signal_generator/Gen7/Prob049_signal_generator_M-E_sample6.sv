module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // 6-bit counter for automatic direction change

// Triangle wave generation logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
        wave <= 5'b0;
    end else begin
        // The counter will naturally overflow/underflow to change direction
        counter <= counter + 1;
        
        // Convert counter to triangle wave
        if (counter[5]) begin  // Counting down phase
            wave <= ~counter[4:0];
        end else begin         // Counting up phase
            wave <= counter[4:0];
        end
    end
end

endmodule