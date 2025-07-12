module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire pattern_match;

// Shift register implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Parallel pattern matching
assign pattern_match = (shift_reg == 4'b1001);

// Registered output with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sequence_detected <= 1'b0;
    end else begin
        sequence_detected <= pattern_match;
    end
end

endmodule