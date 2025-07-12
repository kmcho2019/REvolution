module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6; // Must be even number (2, 4, 6, ...)
reg [NUM_DIV-1:0] pattern;

// Generate initial pattern with 50% duty cycle
localparam HALF_DIV = NUM_DIV >> 1;
initial begin
    pattern = {HALF_DIV{1'b0}};
    pattern[HALF_DIV-1] = 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pattern <= {HALF_DIV{1'b0}};
        pattern[HALF_DIV-1] <= 1'b1;
    end else begin
        // Rotate right with wrap-around
        pattern <= {pattern[0], pattern[NUM_DIV-1:1]};
    end
end

assign clk_div = pattern[NUM_DIV-1];

endmodule