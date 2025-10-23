module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg state;           // 0: counting up, 1: counting down
    reg next_state;
    reg [4:0] next_wave;

    always @(*) begin
        // Default assignments
        next_state = state;
        next_wave  = wave;

        case (state)
            1'b0: begin // counting up
                if (wave == 5'd31) begin
                    next_state = 1'b1;      // switch direction
                    next_wave  = wave - 1;  // start counting down
                end else begin
                    next_wave = wave + 1;
                end
            end

            1'b1: begin // counting down
                if (wave == 5'd0) begin
                    next_state = 1'b0;      // switch direction
                    next_wave  = wave + 1;  // start counting up
                end else begin
                    next_wave = wave - 1;
                end
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            wave  <= next_wave;
            state <= next_state;
        end
    end

endmodule