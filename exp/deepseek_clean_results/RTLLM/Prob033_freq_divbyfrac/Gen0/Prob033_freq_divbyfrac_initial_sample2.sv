module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;

// Counter logic (counts 0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// First divided clock (alternates between 3 and 4 cycles high/low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else begin
        case (counter)
            3'd0: clk_div1 <= 1'b1;
            3'd3: clk_div1 <= 1'b0;
            3'd4: clk_div1 <= 1'b1;
            default: clk_div1 <= clk_div1;
        endcase
    end
end

// Second divided clock (phase shifted version)
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