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

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        
        // Output is only high when we complete the sequence
        data_out <= (state == GOT_1) && !data_in;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            next_state = data_in ? IDLE : GOT_0;
        end
        
        GOT_0: begin
            next_state = data_in ? GOT_1 : GOT_0;
        end
        
        GOT_1: begin
            next_state = data_in ? IDLE : IDLE;
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule