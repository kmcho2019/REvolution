module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1
} state_t;

state_t current_state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        current_state <= next_state;
        
        // Output is high only when we complete the 0->1->0 sequence
        data_out <= (current_state == GOT_1) && (data_in == 1'b0);
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        end
        GOT_0: begin
            next_state = (data_in == 1'b1) ? GOT_1 : 
                        (data_in == 1'b0) ? GOT_0 : IDLE;
        end
        GOT_1: begin
            next_state = (data_in == 1'b0) ? IDLE : IDLE;
        end
        default: next_state = IDLE;
    endcase
end

endmodule