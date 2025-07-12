module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State encoding
    localparam STATE_INC = 1'b0;
    localparam STATE_DEC = 1'b1;

    reg state, next_state;
    reg [4:0] next_wave;

    // Combinational logic for next state and next wave
    always @(*) begin
        next_state = state;
        next_wave = wave;
        case (state)
            STATE_INC: begin
                if (wave == 5'd31) begin
                    next_state = STATE_DEC;
                    next_wave = wave - 1;
                end else begin
                    next_wave = wave + 1;
                end
            end
            STATE_DEC: begin
                if (wave == 5'd0) begin
                    next_state = STATE_INC;
                    next_wave = wave + 1;
                end else begin
                    next_wave = wave - 1;
                end
            end
            default: begin
                next_state = STATE_INC;
                next_wave = 5'd0;
            end
        endcase
    end

    // Sequential logic: state and wave update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_INC;
            wave <= 5'd0;
        end else begin
            state <= next_state;
            wave <= next_wave;
        end
    end

endmodule