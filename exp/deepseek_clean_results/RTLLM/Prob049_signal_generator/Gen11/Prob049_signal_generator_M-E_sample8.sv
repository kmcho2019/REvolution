module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg signed [5:0] counter;  // MSB is sign, [4:0] is magnitude

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'sb0_00000;
        wave <= 5'b0;
    end else begin
        // Update counter with direction-aware increment
        if (counter[5]) begin  // Negative direction
            if (counter[4:0] == 5'b00000) begin
                counter <= counter + 6'sb0_00001;  // Switch to positive
            end else begin
                counter <= counter - 6'sb0_00001;
            end
        end else begin  // Positive direction
            if (counter[4:0] == 5'b11111) begin
                counter <= counter - 6'sb0_00001;  // Switch to negative
            end else begin
                counter <= counter + 6'sb0_00001;
            end
        end
        
        // Output is absolute value of counter
        wave <= counter[4:0];
    end
end

endmodule