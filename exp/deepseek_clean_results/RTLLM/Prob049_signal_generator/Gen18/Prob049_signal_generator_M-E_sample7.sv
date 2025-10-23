module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // Direction: 0=up, 1=down

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        dir <= 1'b0;
    end else begin
        // Update wave based on direction
        if (dir) begin
            wave <= wave - 1;
        end else begin
            wave <= wave + 1;
        end

        // Check for direction change at boundaries
        if (wave == 5'd30 && !dir) begin  // About to reach 31
            dir <= 1'b1;
        end else if (wave == 5'd1 && dir) begin  // About to reach 0
            dir <= 1'b0;
        end
    end
end

endmodule