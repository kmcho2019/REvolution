module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] shift_reg;              // 4-bit shift register
reg [1:0] state;                  // State machine state

// State machine states
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state machine and shift register
        state <= IDLE;
        shift_reg <= 4'b0000;
        valid_out <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                // Load new parallel data into shift register
                shift_reg <= d;
                state <= SHIFT;
                valid_out <= 1'b1;
            end
            SHIFT: begin
                // Shift out bits of shift register
                shift_reg <= {shift_reg[2:0], 1'b0};
                if (shift_reg[3] == 1'b0) begin
                    // If all bits have been shifted out, return to idle state
                    state <= IDLE;
                    valid_out <= 1'b0;
                end
            end
            default: begin
                state <= IDLE;
                shift_reg <= 4'b0000;
                valid_out <= 1'b0;
            end
        endcase
    end
end

assign dout = shift_reg[3];       // Assign most significant bit of shift register to output

endmodule