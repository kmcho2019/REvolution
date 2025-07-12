module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            if (state == 1'b0) begin // incrementing
                if (wave == 5'd31) begin
                    state <= 1'b1;
                    // wave holds at 31 automatically, no need to assign explicitly
                end else begin
                    wave <= wave + 1;
                end
            end else begin // state == 1, decrementing
                if (wave == 5'd0) begin
                    state <= 1'b0;
                    // wave holds at 0 automatically
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule