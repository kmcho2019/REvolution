module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// State encoding
parameter IDLE = 1'b0;
parameter WAIT_FOR_LAST_1 = 1'b1;

// Internal registers
reg [2:0] shift_reg;
reg state, next_state;

// Next state logic (combinational)
always @* begin
    case (state)
        IDLE: 
            next_state = (shift_reg[1:0] == 2'b10 && data_in == 1'b0) ? WAIT_FOR_LAST_1 : IDLE;
        WAIT_FOR_LAST_1: 
            next_state = IDLE;
        default: 
            next_state = IDLE;
    endcase
end

// State register and shift register updates (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        shift_reg <= 3'b0;
    end
    else begin
        state <= next_state;
        shift_reg <= {shift_reg[1:0], data_in};
    end
end

// Output logic (combinational)
assign sequence_detected = (state == WAIT_FOR_LAST_1) && data_in && (shift_reg == 3'b100);

endmodule