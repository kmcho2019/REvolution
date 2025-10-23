module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

reg [3:0] shift_reg;
wire shift_enable;

// Clock gating: Only shift when we're not in final state or when reset
assign shift_enable = !sequence_detected || !rst_n;

// Shift register implementation with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 4'b0;
    end
    else if (shift_enable) begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Explicit bit-wise pattern matching for clarity
assign sequence_detected = (shift_reg == 4'b1001);

endmodule