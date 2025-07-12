module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1
} state_t;

reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        // Output logic: pulse only when we complete 0->1->0 sequence
        data_out <= (state == GOT_1 && !data_in) ? 1'b1 : 1'b0;
    end
end

// Next state logic
always @(*) begin
    case (state)
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