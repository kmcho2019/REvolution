module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// One-hot state encoding
reg state_idle, state_wait;

// 3-bit shift register
reg [2:0] shift_reg;

// Next state wires
wire next_idle, next_wait;

// State transition conditions
wire condition_start = (shift_reg[1:0] == 2'b10) && (data_in == 1'b0);
wire condition_complete = (shift_reg == 3'b100) && data_in;

// State transition logic (combinational)
assign next_idle = !state_wait || (state_wait && condition_complete);
assign next_wait = state_idle && condition_start;

// Output logic (combinational)
assign sequence_detected = state_wait && condition_complete;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        state_idle <= 1'b1;
        state_wait <= 1'b0;
    end
    else begin
        // Update shift register
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Update state
        state_idle <= next_idle;
        state_wait <= next_wait;
    end
end

endmodule