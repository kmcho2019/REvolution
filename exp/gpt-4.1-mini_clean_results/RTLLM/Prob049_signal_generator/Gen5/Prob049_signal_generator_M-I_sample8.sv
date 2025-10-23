module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    // State update logic - changes only at boundaries
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
        end else begin
            if (state == 1'b0 && wave == 5'd31)
                state <= 1'b1;
            else if (state == 1'b1 && wave == 5'd0)
                state <= 1'b0;
        end
    end

    // Waveform update logic - increments or decrements based on state
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
        end else begin
            if (state == 1'b0) 
                wave <= wave + 5'd1;
            else 
                wave <= wave - 5'd1;
        end
    end

endmodule