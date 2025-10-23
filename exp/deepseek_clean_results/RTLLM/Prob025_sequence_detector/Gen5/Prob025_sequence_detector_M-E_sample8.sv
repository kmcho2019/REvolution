module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

reg [3:0] shift_reg;

// Shift register implementation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 4'b0;
    else
        shift_reg <= {shift_reg[2:0], data_in};
end

// Parallel pattern matching
assign sequence_detected = (shift_reg == 4'b1001);

endmodule