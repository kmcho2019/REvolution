module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

wire [3:0] shift_reg_next;
reg [3:0] shift_reg;

// Clear shift register implementation with continuous assignment
assign shift_reg_next = {shift_reg[2:0], data_in};

// Single always block for sequential elements
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        shift_reg <= 4'b0;
    else
        shift_reg <= shift_reg_next;
end

// Minimal pattern matching with direct bit checks
assign sequence_detected = (shift_reg == 4'b1001);

endmodule