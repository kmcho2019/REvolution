module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Binary state encoding
typedef enum logic [1:0] {
    IDLE   = 2'b00,
    GOT_0  = 2'b01,
    GOT_01 = 2'b10
} state_t;

state_t state, next_state;

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        // Registered output - detects falling edge after 01
        data_out <= (state == GOT_01) && (data_in == 0);
    end
end

// Next state logic - optimized binary encoding
always @(*) begin
    case (state)
        IDLE:   next_state = data_in ? IDLE : GOT_0;
        GOT_0:  next_state = data_in ? GOT_01 : GOT_0;
        GOT_01: next_state = data_in ? GOT_01 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule