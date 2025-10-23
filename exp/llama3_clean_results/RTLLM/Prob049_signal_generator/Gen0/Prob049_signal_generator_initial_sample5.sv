module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_next;
reg [0:0] state; // 0: increment, 1: decrement
reg [0:0] state_next;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        wave <= 0;
    end else begin
        state <= state_next;
        wave <= wave_next;
    end
end

always @(*) begin
    wave_next = wave;
    state_next = state;
    
    case (state)
        0: begin
            wave_next = wave + 1;
            if (wave == 31) begin
                state_next = 1;
            end
        end
        1: begin
            wave_next = wave - 1;
            if (wave == 0) begin
                state_next = 0;
            end
        end
        default: begin
            state_next = 0;
            wave_next = 0;
        end
    endcase
end

endmodule