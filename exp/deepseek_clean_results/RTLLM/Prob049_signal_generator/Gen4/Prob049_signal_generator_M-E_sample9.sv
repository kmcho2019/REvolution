module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] up_count;
reg [4:0] down_count;
reg direction;  // 0 = up, 1 = down

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        up_count <= 5'b0;
        down_count <= 5'b11111;
        direction <= 1'b0;
        wave <= 5'b0;
    end else begin
        // Update counters in parallel
        up_count <= (up_count == 5'b11111) ? 5'b0 : up_count + 1;
        down_count <= (down_count == 5'b0) ? 5'b11111 : down_count - 1;
        
        // Simple boundary detection using MSB
        if (direction == 0 && up_count[4]) begin
            direction <= 1'b1;
        end else if (direction == 1 && !down_count[4] && down_count != 0) begin
            direction <= 1'b0;
        end
        
        // Output selection
        wave <= direction ? down_count : up_count;
    end
end

endmodule