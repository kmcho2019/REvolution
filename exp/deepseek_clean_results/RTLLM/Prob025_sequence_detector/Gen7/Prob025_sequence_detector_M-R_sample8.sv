module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

wire [3:0] shift_reg_next;
reg [3:0] shift_reg;

// Shift register implementation using continuous assignments
assign shift_reg_next = {shift_reg[2:0], data_in};

// Register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 4'b0;
    else
        shift_reg <= shift_reg_next;
end

// Parallel pattern matching with explicit bit comparison
assign sequence_detected = (shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0]);

endmodule