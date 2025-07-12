module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
    end
    else begin
        if (wave == 5'd31)         // At max, start decreasing
            wave <= wave - 1;
        else if (wave == 5'd0)     // At min, start increasing
            wave <= wave + 1;
        else if (wave[4])          // MSB=1 means we're decreasing
            wave <= wave - 1;
        else                       // MSB=0 means we're increasing
            wave <= wave + 1;
    end
end

endmodule