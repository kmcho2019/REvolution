module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_a <= 0;
    end else begin
        if (counter == 3'd6) begin
            counter <= 0;
            clk_a <= ~clk_a;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Create phase-shifted version (180°)
wire clk_b = ~clk_a;

// Combine phases to get fractional division
assign clk_div = clk_a | clk_b;

endmodule