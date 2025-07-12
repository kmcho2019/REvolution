module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

// 3-bit counter counts from 0 to 6 (7 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        if (counter == 3'd6) begin
            counter <= 3'b0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// First phase clock (toggles every 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else if (counter == 3'd3) begin
        clk_div1 <= ~clk_div1;
    end
end

// Second phase clock (toggles every 3 cycles, shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else if (counter == 3'd0 || counter == 3'd3) begin
        clk_div2 <= ~clk_div2;
    end
end

// Combine both phases to get fractional division
assign clk_div = clk_div1 | clk_div2;

endmodule