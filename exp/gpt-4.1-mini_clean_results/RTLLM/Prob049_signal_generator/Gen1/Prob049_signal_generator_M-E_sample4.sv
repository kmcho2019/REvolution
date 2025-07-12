module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: up, 1: down

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0;
        end else begin
            if (direction == 1'b0) begin
                if (wave == 5'd31) begin
                    direction <= 1'b1;
                    wave <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin // direction == 1
                if (wave == 5'd0) begin
                    direction <= 1'b0;
                    wave <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule