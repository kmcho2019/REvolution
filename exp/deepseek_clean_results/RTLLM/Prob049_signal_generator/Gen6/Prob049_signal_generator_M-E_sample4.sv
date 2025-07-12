module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // 0=increment, 1=decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        dir <= 1'b0;
    end
    else begin
        // Update wave based on current direction
        wave <= wave + (dir ? -1 : 1);
        
        // Toggle direction at boundaries
        if ((wave == 5'b11110 && !dir) ||  // About to hit 31
            (wave == 5'b00001 && dir)) begin  // About to hit 0
            dir <= ~dir;
        end
    end
end

endmodule