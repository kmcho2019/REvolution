module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg toggle;
reg clk_main;
reg clk_shift;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        toggle <= 1'b0;
        clk_main <= 1'b0;
    end else begin
        if (counter == 3'd6) begin
            counter <= 3'b0;
            toggle <= ~toggle;
        end else begin
            counter <= counter + 1'b1;
        end

        // Main clock generation
        if (toggle) begin
            clk_main <= (counter < 3'd3);  // 3 cycles high
        end else begin
            clk_main <= (counter < 3'd4);  // 4 cycles high
        end
    end
end

// Phase-shifted clock (180° offset)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shift <= 1'b0;
    end else begin
        clk_shift <= clk_main;
    end
end

// Combine both clocks
assign clk_div = clk_main | clk_shift;

endmodule