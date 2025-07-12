module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// Gray-coded state encoding
localparam [1:0] IDLE = 2'b00;
localparam [1:0] S1   = 2'b01;
localparam [1:0] S10  = 2'b11;

reg [1:0] current_state, next_state;
reg [1:0] shift_reg; // Stores last 2 bits

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        shift_reg <= 2'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        shift_reg <= {shift_reg[0], data_in};
        
        // Output is high when we see '01' in shift reg and current bit is 1,
        // and we're in S10 state (meaning previous bits were '10')
        sequence_detected <= (current_state == S10) && (shift_reg == 2'b01) && data_in;
    end
end

always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = (shift_reg[0] & ~data_in) ? S10 : 
                         (data_in ? S1 : IDLE);
        S10:  next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule