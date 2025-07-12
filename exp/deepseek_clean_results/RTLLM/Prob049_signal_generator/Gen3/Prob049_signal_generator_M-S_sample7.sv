module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = count up, 1 = count down

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        // Simple counting operation
        wave <= wave + (direction ? -1 : 1);
        
        // Boundary detection and direction toggle
        if (wave == 5'b11110 && !direction)  // About to hit 31
            direction <= 1'b1;
        else if (wave == 5'b00001 && direction)  // About to hit 0
            direction <= 1'b0;
    end
end

endmodule