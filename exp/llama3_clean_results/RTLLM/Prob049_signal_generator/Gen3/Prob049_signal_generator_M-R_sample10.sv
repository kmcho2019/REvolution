module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

typedef enum logic [0:0] {
    INC,
    DEC
} state_t;

state_t state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= INC;
        wave <= 5'b00000;
    end else begin
        state <= next_state;
        case (state)
            INC: begin
                if (wave == 5'b11111) begin
                    next_state <= DEC;
                    wave <= wave;
                end else begin
                    next_state <= INC;
                    wave <= wave + 1'b1;
                end
            end
            DEC: begin
                if (wave == 5'b00000) begin
                    next_state <= INC;
                    wave <= wave;
                end else begin
                    next_state <= DEC;
                    wave <= wave - 1'b1;
                end
            end
            default: begin
                next_state <= INC;
                wave <= 5'b00000;
            end
        endcase
    end
end

endmodule