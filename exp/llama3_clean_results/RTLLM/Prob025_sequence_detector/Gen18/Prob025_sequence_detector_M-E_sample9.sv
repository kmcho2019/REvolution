module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the shift register
reg [3:0] shift_reg;

// Shift register logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Define the desired sequence
reg [3:0] desired_sequence = 4'b1001;

// Comparator logic
assign sequence_detected = (shift_reg == desired_sequence);

endmodule