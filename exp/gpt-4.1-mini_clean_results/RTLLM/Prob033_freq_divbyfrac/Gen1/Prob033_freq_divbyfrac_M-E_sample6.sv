module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Toggle periods alternate between 3 and 4 input clock cycles
    localparam integer PERIOD_A = 3;
    localparam integer PERIOD_B = 4;

    reg [2:0] count;         // Count input clock cycles up to current toggle period
    reg        current_period; // 0: use PERIOD_A (3), 1: use PERIOD_B (4)

    // On reset, initialize all registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count          <= 3'd0;
            current_period <= 1'b1; // Start with PERIOD_B=4 for first toggle delay
            clk_div        <= 1'b0;
        end else begin
            if (count == (current_period ? PERIOD_B - 1 : PERIOD_A - 1)) begin
                // Toggle output clock
                clk_div <= ~clk_div;
                // Reset counter
                count <= 3'd0;
                // Switch toggle period for next cycle
                current_period <= ~current_period;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule