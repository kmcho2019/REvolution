module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Enumerated type for FSM states
enum logic [1:0] {
    IDLE,
    BIT3,
    BIT2,
    BIT1,
    BIT0
} state, next_state;

// Internal registers
reg [3:0] data_reg;               // Data register to store parallel input
reg [3:0] shift_reg;              // Shift register to shift out bits

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and registers
        state <= IDLE;
        data_reg <= 4'b0000;
        shift_reg <= 4'b0000;
    end else begin
        // Update state and registers based on next state
        state <= next_state;
        case (state)
            IDLE: begin
                // Load parallel input into data register
                data_reg <= d;
                // Initialize shift register
                shift_reg <= data_reg;
            end
            BIT3: begin
                // Shift out most significant bit
                shift_reg <= {1'b0, shift_reg[3:1]};
            end
            BIT2: begin
                // Shift out second most significant bit
                shift_reg <= {1'b0, shift_reg[3:1]};
            end
            BIT1: begin
                // Shift out third most significant bit
                shift_reg <= {1'b0, shift_reg[3:1]};
            end
            BIT0: begin
                // Shift out least significant bit
                shift_reg <= {1'b0, shift_reg[3:1]};
                // Reset data register
                data_reg <= 4'b0000;
            end
        endcase
    end
end

// Next state logic
always @ (*) begin
    case (state)
        IDLE: next_state = BIT3;
        BIT3: next_state = BIT2;
        BIT2: next_state = BIT1;
        BIT1: next_state = BIT0;
        BIT0: next_state = IDLE;
    endcase
end

// Assign valid signal based on state
assign valid_out = (state == IDLE) ? 1 : 0;

// Assign serial output based on shift register
assign dout = shift_reg[3];

endmodule