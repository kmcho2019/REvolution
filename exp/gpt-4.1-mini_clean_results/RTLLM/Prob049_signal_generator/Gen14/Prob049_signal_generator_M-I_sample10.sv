module signal_generator (
    input         clk,
    input         rst_n,
    output reg [4:0] wave
);

    reg direction; // 1: up, 0: down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            direction <= 1'b1; // start incrementing
        end else begin
            // Local next values to reduce combinational complexity
            reg [4:0] next_wave;
            reg next_direction;

            next_wave = wave;
            next_direction = direction;

            if (direction) begin // counting up
                if (wave == 5'd31) begin
                    next_direction = 1'b0; // switch to down
                    // wave stays at 31 for one cycle to avoid immediate toggle
                end else begin
                    next_wave = wave + 1'b1;
                end
            end else begin // counting down
                if (wave == 5'd0) begin
                    next_direction = 1'b1; // switch to up
                    // wave stays at 0 for one cycle to avoid immediate toggle
                end else begin
                    next_wave = wave - 1'b1;
                end
            end

            wave <= next_wave;
            direction <= next_direction;
        end
    end

endmodule