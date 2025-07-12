module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Reduced state encoding with 3 states
localparam [1:0] IDLE = 2'b00;
localparam [1:0] GOT1 = 2'b01;
localparam [1:0] GOT10 = 2'b10;

reg [1:0] current_state, next_state;

// State register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

// Simplified next state logic
always @(*) begin
    case (current_state)
        IDLE: next_state = data_in ? GOT1 : IDLE;
        GOT1: next_state = data_in ? GOT1 : GOT10;
        GOT10: next_state = data_in ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Mealy output - depends on current state AND input
always @(*) begin
    sequence_detected = (current_state == GOT10) && data_in;
end

endmodule