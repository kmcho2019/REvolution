module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);
    reg [4:0] wave_reg;
    reg state;
    reg state_next;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 0;
            wave_reg <= 0;
        end else begin
            state <= state_next;
            wave_reg <= wave;
        end
    end

    always @(*) begin
        case (state)
            0: begin
                wave = wave_reg + 1;
                if (wave_reg == 5'd31) begin
                    state_next = 1;
                end else begin
                    state_next = 0;
                end
            end
            1: begin
                wave = wave_reg - 1;
                if (wave_reg == 5'd0) begin
                    state_next = 0;
                end else begin
                    state_next = 1;
                end
            end
            default: begin
                wave = wave_reg;
                state_next = state;
            end
        endcase
    end

    assign wave = wave_reg;
endmodule