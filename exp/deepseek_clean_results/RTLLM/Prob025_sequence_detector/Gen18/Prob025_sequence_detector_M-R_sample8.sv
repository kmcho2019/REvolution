module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// State encoding parameters
parameter IDLE = 2'b00;
parameter S1   = 2'b01;  // Received '1'
parameter S2   = 2'b10;  // Received '10'
parameter S3   = 2'b11;  // Received '100'

reg [1:0] current_state, next_state;

// State register (sequential logic)
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Next state logic (combinational)
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic (combinational)
assign sequence_detected = (current_state == S3) && data_in;

endmodule