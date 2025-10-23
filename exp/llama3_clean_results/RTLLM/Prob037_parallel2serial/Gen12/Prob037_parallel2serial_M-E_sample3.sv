module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define states
enum logic [1:0] {
    IDLE = 2'b00,
    BIT3 = 2'b01,
    BIT2 = 2'b10,
    BIT1 = 2'b11
} state, next_state;

// Internal registers
reg [3:0] data_reg;               // Data register to store parallel input data
reg [1:0] state_reg;              // State register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and data registers
        state_reg <= IDLE;
        data_reg <= 4'b0000;
    end else begin
        // Update state register
        state_reg <= next_state;
        // Update data register
        if (state_reg == IDLE) begin
            data_reg <= d;
        end
    end
end

always @ (*) begin
    // Next state logic
    case (state_reg)
        IDLE: next_state = BIT3;
        BIT3: next_state = BIT2;
        BIT2: next_state = BIT1;
        BIT1: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic
assign valid_out = (state_reg!= IDLE);
assign dout = (state_reg == BIT3)? data_reg[3] :
              (state_reg == BIT2)? data_reg[2] :
              (state_reg == BIT1)? data_reg[1] : 1'b0;

endmodule