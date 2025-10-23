module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1)/2;

reg [31:0] counter;
reg clk_high;
reg clk_low;

assign clk_div = clk_high | clk_low;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_high <= 0;
        clk_low <= 0;
    end else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
            clk_low <= ~clk_low;  // Toggle low phase at full period
        end else begin
            counter <= counter + 1;
        end

        // Toggle high phase at half period
        if (counter == HALF_DIV - 1) begin
            clk_high <= ~clk_high;
        end
    end
end

endmodule