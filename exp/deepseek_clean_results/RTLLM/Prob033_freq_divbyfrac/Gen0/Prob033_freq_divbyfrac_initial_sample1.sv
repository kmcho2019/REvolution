module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;
wire clk_div2_delayed;

// Counter logic (counts 0-6 for 7 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Generate clk_div1 (alternates between 4 and 3 cycles high)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else begin
        if (counter == 3'd0) begin
            clk_div1 <= 1'b1;
        end else if (counter == 3'd3 || counter == 3'd6) begin
            clk_div1 <= 1'b0;
        end
    end
end

// Generate phase-shifted version (using negative edge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        clk_div2 <= clk_div1;
    end
end

// Final output combines both clocks
assign clk_div = clk_div1 | clk_div2;

endmodule