module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction; // 0: incrementing, 1: decrementing
reg clk_en; // clock enable signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 0;
        clk_en <= 0;
    end else begin
        case (direction)
            0: begin
                if (counter == 31) begin
                    direction <= 1;
                    clk_en <= 0;
                end else begin
                    counter <= counter + 1;
                    clk_en <= 1;
                end
            end
            1: begin
                if (counter == 0) begin
                    direction <= 0;
                    clk_en <= 0;
                end else begin
                    counter <= counter - 1;
                    clk_en <= 1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (clk_en) begin
        wave <= counter;
    end
end

endmodule