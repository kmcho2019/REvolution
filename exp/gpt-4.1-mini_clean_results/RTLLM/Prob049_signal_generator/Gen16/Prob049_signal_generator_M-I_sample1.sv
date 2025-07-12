module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start by incrementing
        end else begin
            // Update wave inline, increment if state=0 else decrement
            if (state == 1'b0) begin
                if (wave < 5'd31)
                    wave <= wave + 5'd1;
                else
                    wave <= wave; // hold at max
            end else begin
                if (wave > 5'd0)
                    wave <= wave - 5'd1;
                else
                    wave <= wave; // hold at min
            end

            // Toggle state only when wave reached boundary and held
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0))
                state <= ~state;
        end
    end

endmodule