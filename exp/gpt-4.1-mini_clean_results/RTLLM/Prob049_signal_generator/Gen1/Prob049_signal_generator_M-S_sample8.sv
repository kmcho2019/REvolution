module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg dir; // 0: up, 1: down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            dir  <= 1'b0;
        end else begin
            if (dir == 1'b0) begin
                wave <= wave + 5'd1;
                if (wave == 5'd31)
                    dir <= 1'b1;
            end else begin
                wave <= wave - 5'd1;
                if (wave == 5'd0)
                    dir <= 1'b0;
            end
        end
    end

endmodule