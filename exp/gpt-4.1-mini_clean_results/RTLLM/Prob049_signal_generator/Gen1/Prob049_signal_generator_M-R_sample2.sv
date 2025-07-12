module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg state;
    reg [4:0] next_wave;
    reg next_state;

    always @(*) begin
        // Default assignments to hold values
        next_wave = wave;
        next_state = state;

        case (state)
            1'b0: begin
                next_wave = wave + 1;
                if (wave == 5'd31)
                    next_state = 1'b1;
            end
            1'b1: begin
                next_wave = wave - 1;
                if (wave == 5'd0)
                    next_state = 1'b0;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave <= 5'd0;
        end else begin
            state <= next_state;
            wave <= next_wave;
        end
    end

endmodule