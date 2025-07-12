module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    reg direction; // 1 = up, 0 = down
    reg [4:0] next_wave;
    reg next_direction;

    // Combinational logic to determine next wave value and direction
    always @(*) begin
        if (direction) begin
            // Counting up
            if (wave == 5'd31) begin
                next_wave      = wave - 5'd1;
                next_direction = 1'b0; // switch direction to down
            end else begin
                next_wave      = wave + 5'd1;
                next_direction = direction;
            end
        end else begin
            // Counting down
            if (wave == 5'd0) begin
                next_wave      = wave + 5'd1;
                next_direction = 1'b1; // switch direction to up
            end else begin
                next_wave      = wave - 5'd1;
                next_direction = direction;
            end
        end
    end

    // Sequential update on posedge clk or negedge rst_n
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b1; // start counting up
        end else begin
            wave      <= next_wave;
            direction <= next_direction;
        end
    end

endmodule