module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg dir; // direction: 1 = increment, 0 = decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            dir  <= 1'b1; // start by incrementing
        end else begin
            if (dir) begin
                // increment wave
                if (wave == 5'd31) begin
                    dir <= 1'b0;       // switch to decrement
                    wave <= wave - 1;  // decrement on next cycle
                end else begin
                    wave <= wave + 1;
                end
            end else begin
                // decrement wave
                if (wave == 5'd0) begin
                    dir <= 1'b1;       // switch to increment
                    wave <= wave + 1;  // increment on next cycle
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule