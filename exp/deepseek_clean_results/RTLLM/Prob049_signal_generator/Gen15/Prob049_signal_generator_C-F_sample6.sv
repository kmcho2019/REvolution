module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement
wire at_max = &wave;   // All 1's detection
wire at_min = ~|wave;  // All 0's detection

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        // Update wave with direction-controlled arithmetic
        wave <= direction ? wave - 1'b1 : wave + 1'b1;
        
        // Update direction at boundaries
        if (at_max && !direction) begin
            direction <= 1'b1;
        end else if (at_min && direction) begin
            direction <= 1'b0;
        end
    end
end

endmodule