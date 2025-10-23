module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase0;
wire clk_phase180;

// 3-bit counter for 7 cycles (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Base clock generation (alternates between 3 and 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase0 <= 1'b0;
    end else begin
        // Toggle at end of 3 or 4 cycle periods
        if ((counter == 3'd2) || (counter == 3'd6)) begin
            clk_phase0 <= ~clk_phase0;
        end
    end
end

// 180-degree phase shifted version (using falling edge)
reg clk_phase180_reg;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase180_reg <= 1'b0;
    end else begin
        clk_phase180_reg <= clk_phase0;
    end
end
assign clk_phase180 = clk_phase180_reg;

// Final output combines both phases
assign clk_div = clk_phase0 | clk_phase180;

endmodule