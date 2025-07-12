module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_phase0;
reg clk_phase180;

// 3-bit counter for 7 cycles (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Base clock generation (3.5 cycle period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase0 <= 1'b0;
    end else begin
        // Toggle at 3 and 6 (4/3 cycle pattern)
        if ((counter == 3'd3) || (counter == 3'd6)) begin
            clk_phase0 <= ~clk_phase0;
        end
    end
end

// 180-degree phase shifted version (1.75 cycle offset)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_phase180 <= 1'b0;
    end else begin
        // Toggle at 1 and 5 (offset pattern)
        if ((counter == 3'd1) || (counter == 3'd5)) begin
            clk_phase180 <= ~clk_phase180;
        end
    end
end

// Final output combines both phases with XOR
assign clk_div = clk_phase0 ^ clk_phase180;

endmodule