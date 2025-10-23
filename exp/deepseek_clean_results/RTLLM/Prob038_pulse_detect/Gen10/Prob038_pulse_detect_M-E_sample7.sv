module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding (one-hot for clarity)
typedef enum logic [2:0] {
    IDLE  = 3'b001,
    GOT_1 = 3'b010,
    GOT_0 = 3'b100
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        IDLE: begin
            data_out = 1'b0;
            if (data_in == 1'b0)
                next_state = IDLE;
            else
                next_state = GOT_1;
        end
        
        GOT_1: begin
            data_out = 1'b0;
            if (data_in == 1'b1)
                next_state = GOT_1;
            else
                next_state = GOT_0;
        end
        
        GOT_0: begin
            data_out = 1'b1;
            if (data_in == 1'b0)
                next_state = IDLE;
            else
                next_state = GOT_1;
        end
        
        default: begin
            data_out = 1'b0;
            next_state = IDLE;
        end
    endcase
end

endmodule