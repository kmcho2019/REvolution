module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                 // FSM state register
reg [3:0] shift_reg;             // Shift register for parallel input data
reg         valid;               // Internal valid signal

// FSM state transitions
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM state and shift register
        state <= 2'b00;
        shift_reg <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin
                // Load parallel input data into shift register
                shift_reg <= d;
                state <= 2'b01;
            end
            2'b01: begin
                // Output most significant bit and shift register
                dout <= shift_reg[3];
                shift_reg <= {shift_reg[2:0], 1'b0};
                state <= 2'b10;
            end
            2'b10: begin
                // Output second most significant bit and shift register
                dout <= shift_reg[3];
                shift_reg <= {shift_reg[2:0], 1'b0};
                state <= 2'b11;
            end
            2'b11: begin
                // Output least significant bits and reset FSM state
                dout <= shift_reg[3];
                shift_reg <= 4'b0000;
                state <= 2'b00;
            end
        endcase
    end
end

// Assert valid signal when in first state
assign valid_out = (state == 2'b00) ? 1 : 0;

endmodule