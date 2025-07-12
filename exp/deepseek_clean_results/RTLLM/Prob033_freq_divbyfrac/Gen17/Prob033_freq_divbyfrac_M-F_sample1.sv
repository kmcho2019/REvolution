module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

// 7-cycle counter (4 high + 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Base divided clock (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else begin
        clk_div1 <= (counter < 3'd4) ? 1'b1 : 1'b0;
    end
end

// Phase-shifted clock (delayed by 2 cycles)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        case (counter)
            3'd1, 3'd2, 3'd3, 3'd4: clk_div2 <= 1'b1;
            default: clk_div2 <= 1'b0;
        endcase
    end
end

// Final output combines both phases
assign clk_div = clk_div1 | clk_div2;

endmodule