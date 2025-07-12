module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Shift register for last 3 bits
reg [2:0] shift_reg;

// State encoding
localparam [1:0] IDLE = 2'b00;
localparam [1:0] GOT1 = 2'b01;
localparam [1:0] GOT10 = 2'b10;

reg [1:0] current_state, next_state;

// Shift register and state update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        shift_reg <= {shift_reg[1:0], data_in};
        current_state <= next_state;
        // Registered output for better timing
        sequence_detected <= (current_state == GOT10) && (data_in == 1'b1);
    end
end

// Next state logic (simplified with shift register)
always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b1) ? GOT1 : IDLE;
        GOT1: next_state = (data_in == 1'b0) ? GOT10 : GOT1;
        GOT10: next_state = (data_in == 1'b0) ? IDLE : GOT1;
        default: next_state = IDLE;
    endcase
end

endmodule