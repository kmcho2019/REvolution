module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    // direction = 0 means counting up, 1 means counting down
    reg direction;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0; // start counting up
        end else begin
            if (direction == 1'b0) begin
                // counting up
                if (wave == 5'd31) begin
                    direction <= 1'b1; // switch direction to down
                    wave <= wave - 1;
                end else begin
                    wave <= wave + 1;
                end
            end else begin
                // counting down
                if (wave == 5'd0) begin
                    direction <= 1'b0; // switch direction to up
                    wave <= wave + 1;
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule