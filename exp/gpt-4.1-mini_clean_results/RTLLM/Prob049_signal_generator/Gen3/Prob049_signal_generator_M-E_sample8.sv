module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg dir; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            dir <= 1'b0;
        end else begin
            if (dir == 1'b0) begin
                if (wave == 5'd31) begin
                    dir <= 1'b1;
                    wave <= wave - 1;
                end else begin
                    wave <= wave + 1;
                end
            end else begin
                if (wave == 5'd0) begin
                    dir <= 1'b0;
                    wave <= wave + 1;
                end else begin
                    wave <= wave - 1;
                end
            end
        end
    end

endmodule