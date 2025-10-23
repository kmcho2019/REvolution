module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (direction) begin
            wave <= wave - 1;
            if (wave == 5'b00001) direction <= 1'b0;
        end else begin
            wave <= wave + 1;
            if (wave == 5'b11110) direction <= 1'b1;
        end
    end
end

endmodule