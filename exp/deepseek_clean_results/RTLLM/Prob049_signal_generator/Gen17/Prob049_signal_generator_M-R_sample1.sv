module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = up, 1 = down
reg [4:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        // Update counter based on direction
        if (direction) begin
            counter <= counter - 1;
        end
        else begin
            counter <= counter + 1;
        end

        // Check for direction change at boundaries
        if (counter == 5'b11111) begin
            direction <= 1'b1;
        end
        else if (counter == 5'b00000) begin
            direction <= 1'b0;
        end
    end
end

// Continuous assignment for output
assign wave = counter;

endmodule