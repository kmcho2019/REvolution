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
        if (counter == 3'd6) begin
            counter <= 3'b0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// First divided clock (alternates between 3 and 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else begin
        if (counter == 3'd0) begin
            clk_div1 <= ~clk_div1;
        end else if (counter == 3'd3 && clk_div1) begin
            clk_div1 <= ~clk_div1;
        end else if (counter == 3'd4 && !clk_div1) begin
            clk_div1 <= ~clk_div1;
        end
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

// Final output clock
assign clk_div = clk_div1 | clk_div2;

endmodule