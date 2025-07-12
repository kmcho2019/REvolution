module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
        dir <= 1;
    end else begin
        if (dir) begin
            if (wave == 31) begin
                dir <= 0;
            end
            wave <= (wave == 31)? 31 : wave + 1;
        end else begin
            if (wave == 0) begin
                dir <= 1;
            end
            wave <= (wave == 0)? 0 : wave - 1;
        end
    end
end

endmodule