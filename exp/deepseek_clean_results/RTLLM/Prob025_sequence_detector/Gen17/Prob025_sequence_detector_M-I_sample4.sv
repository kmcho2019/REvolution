module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire pattern_match;
reg enable_shift;

// Clock gating control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        enable_shift <= 1'b0;
    else if (shift_reg[2:0] == 3'b100 || data_in)
        enable_shift <= 1'b1;
end

// Shift register implementation with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end
    else if (enable_shift) begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Parallel pattern matching
assign pattern_match = (shift_reg == 4'b1001);

// Registered output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sequence_detected <= 1'b0;
    else
        sequence_detected <= pattern_match;
end

endmodule