module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: counting up, 1: counting down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0; // start counting up
        end else begin
            if (direction == 1'b0) begin
                // Counting up
                if (wave == 5'd31) begin
                    direction <= 1'b1; // change to counting down
                    wave <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                // Counting down
                if (wave == 5'd0) begin
                    direction <= 1'b0; // change to counting up
                    wave <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule