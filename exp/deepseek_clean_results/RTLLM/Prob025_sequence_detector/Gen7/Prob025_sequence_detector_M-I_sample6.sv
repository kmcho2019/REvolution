module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Combined shift register (2 bits) + state (1 bit)
reg [2:0] shift_reg; // [2] = state, [1:0] = last two bits
reg sequence_detected_next;

// Clock gating signal
wire update_shift = !rst_n || (shift_reg[2] || (shift_reg[1:0] == 2'b10));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Shift register updates with clock gating
        if (update_shift) begin
            shift_reg <= {shift_reg[1] & ~shift_reg[2], 
                         shift_reg[0] & ~shift_reg[2], 
                         data_in & ~shift_reg[2]};
        end
        
        // State transitions (encoded in shift_reg[2])
        shift_reg[2] <= (shift_reg[1:0] == 2'b10) && (data_in == 1'b0);
        
        // Registered output
        sequence_detected <= sequence_detected_next;
    end
end

// Output logic (combinational)
always @(*) begin
    sequence_detected_next = (shift_reg[2] && data_in) && 
                            (shift_reg[1:0] == 2'b00);
end

endmodule