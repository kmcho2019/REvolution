module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;    // Start incrementing
            wave  <= 5'd0;    // Initialize wave to 0
        end else begin
            if (state == 1'b0) begin // incrementing
                if (wave == 5'd31) begin
                    state <= 1'b1;  // switch to decrement next cycle
                    wave  <= wave;  // hold peak for one cycle
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin // decrementing
                if (wave == 5'd0) begin
                    state <= 1'b0;  // switch to increment next cycle
                    wave  <= wave;  // hold bottom for one cycle
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule