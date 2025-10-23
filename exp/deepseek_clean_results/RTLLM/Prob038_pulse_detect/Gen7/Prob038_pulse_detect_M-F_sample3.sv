module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
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
        
        // Output is high only when we detect the complete pulse
        data_out <= (current_state == GOT_1) && !data_in;
    end
end

always @(*) begin
    case (current_state)
        IDLE: next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        GOT_0: next_state = (data_in == 1'b1) ? GOT_1 : 
                           (data_in == 1'b0) ? GOT_0 : IDLE;
        GOT_1: next_state = (data_in == 1'b0) ? IDLE : GOT_1;
        default: next_state = IDLE;
    endcase
end

endmodule