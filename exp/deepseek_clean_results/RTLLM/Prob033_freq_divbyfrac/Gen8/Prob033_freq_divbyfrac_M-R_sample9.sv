module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_main_pos;
reg clk_shifted_neg;

// Counter (0-6) - simplified state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 6) ? 3'b0 : counter + 1;
    end
end

// Main clock phase (positive edge triggered)
assign clk_main_pos = (counter < 4);

// Shifted clock phase (negative edge triggered)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shifted_neg <= 1'b0;
    end else begin
        // Shifted by half period (3.5 cycles)
        // This creates the complementary phase
        clk_shifted_neg <= (counter >= 4) | (counter < 1);
    end
end

// Combine phases with OR to create uniform output
assign clk_div = clk_main_pos | clk_shifted_neg;

endmodule