module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
        end else begin
            if (wave == 5'd31)
                wave <= wave - 5'd1;
            else if (wave == 5'd0)
                wave <= wave + 5'd1;
            else if (wave[4] == 1'b0)
                wave <= wave + 5'd1;
            else
                wave <= wave - 5'd1;
        end
    end

endmodule