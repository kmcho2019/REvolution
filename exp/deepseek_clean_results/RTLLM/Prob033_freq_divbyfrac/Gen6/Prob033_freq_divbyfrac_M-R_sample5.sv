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

// Main clock (high for 0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_main <= 1'b0;
    end else begin
        clk_main <= (counter < 4);
    end
end

// Shifted clock (half-cycle delayed)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shifted <= 1'b0;
    end else begin
        clk_shifted <= (counter < 4);
    end
end

// Combine phases with XOR for uniform pulses
assign clk_div = clk_main ^ clk_shifted;

endmodule