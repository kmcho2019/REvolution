module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

wire [3:0] shift_reg_next;
reg [3:0] shift_reg;

// Shift register implementation with continuous assignment
assign shift_reg_next = {shift_reg[2:0], data_in};

// Register update and output registration
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        shift_reg <= shift_reg_next;
        // Registered output breaks critical path
        sequence_detected <= (shift_reg_next == 4'b1001);
    end
end

endmodule