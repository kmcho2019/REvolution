module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)
localparam ACC_WIDTH = 16; // Fixed accumulator width

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
    end
end

// Calculate phase increment value
localparam PHASE_INC = (2**(ACC_WIDTH-1)) / (NUM_DIV/2);

reg [ACC_WIDTH-1:0] phase_acc;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 0;
        clk_div <= 0;
    end
    else begin
        phase_acc <= phase_acc + PHASE_INC;
        clk_div <= phase_acc[ACC_WIDTH-1]; // MSB is divided clock
    end
end

endmodule