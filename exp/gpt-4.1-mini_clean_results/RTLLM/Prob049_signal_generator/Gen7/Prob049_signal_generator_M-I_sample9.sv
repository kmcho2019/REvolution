module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    reg direction; // 0: up, 1: down

    // Combinational signals for next state
    reg [4:0] wave_next;
    reg direction_next;

    always @* begin
        // Default assignments
        wave_next = wave;
        direction_next = direction;

        if (direction == 1'b0) begin
            // Counting up
            if (wave == 5'd31) begin
                wave_next = wave - 5'd1;
                direction_next = 1'b1;
            end else begin
                wave_next = wave + 5'd1;
                direction_next = direction;
            end
        end else begin
            // Counting down
            if (wave == 5'd0) begin
                wave_next = wave + 5'd1;
                direction_next = 1'b0;
            end else begin
                wave_next = wave - 5'd1;
                direction_next = direction;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 1'b0;
        end else begin
            wave <= wave_next;
            direction <= direction_next;
        end
    end

endmodule