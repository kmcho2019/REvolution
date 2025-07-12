module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // [5] is direction, [4:0] is wave value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
    end
    else begin
        if (counter[5] == 1'b0) begin  // Counting up
            counter <= counter + 1;
        end
        else begin  // Counting down
            if (counter[4:0] == 5'b0) begin  // About to underflow
                counter <= 6'b0;  // Reset to 0 (with direction=0)
            end
            else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = counter[4:0];

endmodule