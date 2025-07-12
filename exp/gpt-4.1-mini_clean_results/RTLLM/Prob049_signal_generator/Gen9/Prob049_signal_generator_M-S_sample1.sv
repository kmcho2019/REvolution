module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0;
        end else begin
            if (direction == 1'b0) begin
                if (wave == 5'd31)
                    direction <= 1'b1;
                else
                    wave <= wave + 5'd1;
            end else begin
                if (wave == 5'd0)
                    direction <= 1'b0;
                else
                    wave <= wave - 5'd1;
            end
        end
    end

endmodule