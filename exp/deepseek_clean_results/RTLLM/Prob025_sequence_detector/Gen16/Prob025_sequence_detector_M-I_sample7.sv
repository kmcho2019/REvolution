module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// States encoding
localparam IDLE = 2'b00;
localparam S1   = 2'b01;  // Received '1'
localparam S2   = 2'b10;  // Received '10'
localparam S3   = 2'b11;  // Received '100'

reg [1:0] current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? S1 : IDLE;
        S1:   next_state = data_in ? S1 : S2;
        S2:   next_state = data_in ? S3 : IDLE;
        S3:   next_state = data_in ? S1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Output logic - Mealy machine style
assign sequence_detected = (current_state == S3) && data_in;

endmodule