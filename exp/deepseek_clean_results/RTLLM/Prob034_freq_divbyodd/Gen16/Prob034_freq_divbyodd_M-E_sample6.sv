module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Validate parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

// Shift register for edge detection
reg [NUM_DIV-1:0] shift_reg;

// Pulse generators
wire rising_pulse = shift_reg[NUM_DIV-1];
wire falling_pulse = shift_reg[(NUM_DIV-1)/2];

// SR latch for output generation
reg clk_div_reg;

always @(posedge rising_pulse or posedge falling_pulse or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 1'b0;
    end else begin
        if (rising_pulse) clk_div_reg <= 1'b1;
        if (falling_pulse) clk_div_reg <= 1'b0;
    end
end

// Shift register control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {1'b1, {(NUM_DIV-1){1'b0}}};
    end else begin
        shift_reg <= {shift_reg[NUM_DIV-2:0], shift_reg[NUM_DIV-1]};
    end
end

assign clk_div = clk_div_reg;

endmodule