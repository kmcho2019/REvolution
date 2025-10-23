module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = data_in ? IDLE : GOT_0;
        GOT_0:  next_state = data_in ? GOT_1 : GOT_0;
        GOT_1:  next_state = data_in ? IDLE : GOT_0;
        default: next_state = IDLE;
    endcase
end

// Output logic (Mealy style)
assign data_out = (current_state == GOT_1) && !data_in;

endmodule