module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Stores last 3 bits
reg data_in_reg;      // Registered input
reg detected_next;
reg enable_clock;     // Clock gating control

// Clock gating logic - disable when in IDLE state
always @(*) begin
    enable_clock = (|shift_reg) || data_in || sequence_detected;
end

// Input registration and shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        data_in_reg <= 1'b0;
        sequence_detected <= 1'b0;
    end else if (enable_clock) begin
        data_in_reg <= data_in;
        shift_reg <= {shift_reg[1:0], data_in_reg};
        sequence_detected <= detected_next;
    end
end

// Optimized detection logic (1001 pattern)
always @(*) begin
    detected_next = 1'b0;
    // Match when we have 100 in shift_reg and current input is 1
    if (shift_reg == 3'b100 && data_in_reg) begin
        detected_next = 1'b1;
    end
end

endmodule