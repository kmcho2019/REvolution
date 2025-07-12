module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // Direction flag: 0 means counting up, 1 means counting down
    reg direction;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0; // start counting up
        end else begin
            if (direction == 1'b0) begin
                if (wave == 5'd31) begin
                    direction <= 1'b1;    // switch to counting down
                    wave <= wave - 5'd1; // decrement on boundary transition
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                if (wave == 5'd0) begin
                    direction <= 1'b0;    // switch to counting up
                    wave <= wave + 5'd1; // increment on boundary transition
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule