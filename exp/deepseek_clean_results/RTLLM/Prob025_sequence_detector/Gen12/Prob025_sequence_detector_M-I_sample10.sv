module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;  // 4-bit shift register for pattern matching
reg data_in_reg;      // Registered input for better timing
reg enable_clock;     // Clock gating control

// Clock gating and input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_reg <= 1'b0;
        enable_clock <= 1'b1;
    end else begin
        data_in_reg <= data_in;
        // Simple clock gating - disable when in initial state with no matches
        enable_clock <= (shift_reg != 4'b0000) || data_in;
    end
end

// Shift register update with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end else if (enable_clock) begin
        shift_reg <= {shift_reg[2:0], data_in_reg};
        // Direct pattern matching for 1001
        sequence_detected <= (shift_reg[2:0] == 3'b100) && (data_in_reg == 1'b1);
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule