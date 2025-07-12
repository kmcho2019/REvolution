module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// FSM states
typedef enum logic [1:0] {
    IDLE = 2'b00,
    RISE = 2'b01,
    FALL = 2'b10
} state_t;

state_t current_state, next_state;
reg [1:0] cycle_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        cycle_counter <= 2'b0;
        data_out <= 1'b0;
    end else begin
        current_state <= next_state;
        
        // Cycle counter for timing enforcement
        if (current_state != next_state)
            cycle_counter <= 2'b0;
        else if (cycle_counter < 2'b11)
            cycle_counter <= cycle_counter + 1;
            
        // Output generation
        data_out <= (next_state == IDLE) && (current_state == FALL) && 
                    (cycle_counter == 2'b10);
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = data_in ? RISE : IDLE;
        end
        RISE: begin
            if (cycle_counter == 2'b10) begin
                next_state = data_in ? IDLE : FALL;
            end else begin
                next_state = data_in ? RISE : IDLE;
            end
        end
        FALL: begin
            if (cycle_counter == 2'b10) begin
                next_state = IDLE;
            end else begin
                next_state = data_in ? IDLE : FALL;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule