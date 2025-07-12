module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter;
reg toggle;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        toggle <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == 3'd6) begin
            counter <= 3'b0;
            toggle <= ~toggle;
        end else begin
            counter <= counter + 1'b1;
        end

        // Pattern alternation
        if (toggle) begin
            clk_div <= (counter < 3'd3);  // 3 cycles high
        end else begin
            clk_div <= (counter < 3'd4);  // 4 cycles high
        end
    end
end

endmodule