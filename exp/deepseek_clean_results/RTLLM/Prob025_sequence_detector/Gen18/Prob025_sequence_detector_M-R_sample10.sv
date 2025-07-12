module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT1,
    GOT10,
    GOT100
} state_t;

reg [1:0] current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = data_in ? GOT1 : IDLE;
        GOT1:   next_state = data_in ? GOT1 : GOT10;
        GOT10:  next_state = data_in ? GOT1 : GOT100;
        GOT100: next_state = data_in ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Output logic - detected when in GOT100 state and input is 1
assign sequence_detected = (current_state == GOT100) && data_in;

endmodule