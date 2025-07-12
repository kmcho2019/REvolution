module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_main;
reg clk_shifted;

// Counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 6) ? 3'b0 : counter + 1;
    end
end

// Main clock - high for 4 cycles, low for 3 cycles
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_main <= 1'b0;
    end else begin
        if (counter == 0) clk_main <= 1'b1;
        else if (counter == 4) clk_main <= 1'b0;
    end
end

// Shifted clock - same pattern but delayed by 3.5 cycles
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shifted <= 1'b0;
    end else begin
        if (counter == 3) clk_shifted <= 1'b1;
        else if (counter == 0) clk_shifted <= 1'b0;
    end
end

// Combine phases with OR to create uniform output
assign clk_div = clk_main | clk_shifted;

endmodule