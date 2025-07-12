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

localparam HALF_CYCLE = (NUM_DIV - 1) / 2;
reg [31:0] counter;
reg clk_pos, clk_neg;

// Counter that increments on both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        counter <= (counter == NUM_DIV - 1) ? 0 : counter + 1;
    end
end

// Positive edge divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_pos <= 0;
    end else begin
        clk_pos <= (counter < HALF_CYCLE) ? 1'b1 : 1'b0;
    end
end

// Negative edge divided clock
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 0;
    end else begin
        clk_neg <= (counter < HALF_CYCLE) ? 1'b1 : 1'b0;
    end
end

// Combined output clock
assign clk_div = clk_pos | clk_neg;

endmodule