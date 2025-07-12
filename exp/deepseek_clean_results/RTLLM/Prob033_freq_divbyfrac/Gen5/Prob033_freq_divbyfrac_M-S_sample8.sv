module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_shifted;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 6) ? 3'b0 : counter + 1;
    end
end

// Half-cycle delayed version
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_shifted <= 1'b0;
    end else begin
        clk_shifted <= (counter >= 3) && (counter < 6);
    end
end

// Clock generation
wire clk_main = (counter < 4);  // Active for 4 cycles
assign clk_div = clk_main | clk_shifted;

endmodule