module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] state;                 // FSM state register
reg [3:0] data_reg;               // Register to store parallel input data

// FSM state transitions
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset FSM state and data register on reset
        state <= 2'b00;
        data_reg <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin
                // Load parallel input data and transition to next state
                data_reg <= d;
                state <= 2'b01;
            end
            2'b01: begin
                // Shift data register one bit to the right and transition to next state
                data_reg <= {data_reg[2:0], 1'b0};
                state <= 2'b10;
            end
            2'b10: begin
                // Shift data register one bit to the right and transition to next state
                data_reg <= {data_reg[2:0], 1'b0};
                state <= 2'b11;
            end
            2'b11: begin
                // Shift data register one bit to the right and transition back to initial state
                data_reg <= {data_reg[2:0], 1'b0};
                state <= 2'b00;
            end
        endcase
    end
end

// Assign valid signal based on FSM state
assign valid_out = (state == 2'b00);

// Assign serial output based on FSM state
always @ (*) begin
    case (state)
        2'b00: dout = data_reg[3];
        2'b01: dout = data_reg[2];
        2'b10: dout = data_reg[1];
        2'b11: dout = data_reg[0];
    endcase
end

endmodule