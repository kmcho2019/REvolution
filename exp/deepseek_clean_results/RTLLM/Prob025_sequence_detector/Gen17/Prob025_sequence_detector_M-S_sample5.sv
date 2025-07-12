module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

typedef enum {IDLE, GOT1, GOT10, GOT100} state_t;
state_t current_state, next_state;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else begin
        current_state <= next_state;
        // Output is high only when we detect the complete sequence
        sequence_detected <= (current_state == GOT100) && data_in;
    end
end

always @(*) begin
    case (current_state)
        IDLE:   next_state = data_in ? GOT1 : IDLE;
        GOT1:   next_state = data_in ? GOT1 : GOT10;
        GOT10:  next_state = data_in ? GOT1 : GOT100;
        GOT100: next_state = data_in ? GOT1 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule