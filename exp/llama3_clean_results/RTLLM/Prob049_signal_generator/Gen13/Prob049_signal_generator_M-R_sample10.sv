module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // direction (0: increment, 1: decrement)

always @(negedge rst_n) begin
    wave <= 0;
    dir <= 0;
end

always @(posedge clk) begin
    if (~rst_n) begin
        wave <= 0;
        dir <= 0;
    end else begin
        if (dir == 0) begin
            wave <= (wave == 31)? 0 : wave + 1;
            if (wave == 31) begin
                dir <= 1;
            end
        end else begin
            wave <= (wave == 0)? 31 : wave - 1;
            if (wave == 0) begin
                dir <= 0;
            end
        end
    end
end

endmodule