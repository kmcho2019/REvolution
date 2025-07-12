module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg dir; // Direction: 0 = up, 1 = down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            dir  <= 1'b0;
        end else begin
            if (dir == 1'b0) begin
                // Counting up
                if (wave == 5'd31) begin
                    dir  <= 1'b1;       // Change direction to down
                    wave <= wave - 1;  // Start decrementing
                end else begin
                    wave <= wave + 1;
                end
            end else begin
                // Counting down
                if (wave == 5'd0) begin
                    dir  <= 1'b0;       // Change direction to up
                    wave <= wave + 1;  // Start incrementing
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule