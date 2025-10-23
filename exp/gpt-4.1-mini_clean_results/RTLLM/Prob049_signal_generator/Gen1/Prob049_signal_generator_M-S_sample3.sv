module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg direction; // 0: up, 1: down

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 0;
            direction <= 0;
        end else begin
            if (direction == 0) begin
                if (wave == 5'd31)
                    direction <= 1;
                else
                    wave <= wave + 1;
            end else begin
                if (wave == 5'd0)
                    direction <= 0;
                else
                    wave <= wave - 1;
            end
        end
    end

endmodule