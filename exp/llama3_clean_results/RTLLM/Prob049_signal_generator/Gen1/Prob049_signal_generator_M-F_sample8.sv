module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_next;
reg state;
reg state_next;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        wave <= 0;
    end else begin
        if (state == 0) begin
            wave_next = wave + 1;
            if (wave == 31) begin
                state_next = 1;
            end else begin
                state_next = 0;
            end
        end else begin
            wave_next = wave - 1;
            if (wave == 0) begin
                state_next = 0;
            end else begin
                state_next = 1;
            end
        end
        state <= state_next;
        wave <= wave_next;
    end
end

endmodule