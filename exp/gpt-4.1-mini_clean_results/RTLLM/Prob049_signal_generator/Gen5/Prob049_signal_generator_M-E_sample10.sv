module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0; // start incrementing
        end else begin
            if (direction == 1'b0) begin // increment
                if (wave == 5'd31) begin
                    direction <= 1'b1; // switch to decrement
                    wave      <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin // decrement
                if (wave == 5'd0) begin
                    direction <= 1'b0; // switch to increment
                    wave      <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule