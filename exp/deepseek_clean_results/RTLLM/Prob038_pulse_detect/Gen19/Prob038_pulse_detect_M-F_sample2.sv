module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1
} state_t;

state_t state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        
        // Output is 1 only when we complete the sequence
        data_out <= (state == GOT_1 && data_in == 1'b0);
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
        GOT_0: next_state = (data_in == 1'b1) ? GOT_1 : 
                           (data_in == 1'b0) ? GOT_0 : IDLE;
        GOT_1: next_state = (data_in == 1'b0) ? IDLE : 
                           (data_in == 1'b1) ? GOT_1 : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule