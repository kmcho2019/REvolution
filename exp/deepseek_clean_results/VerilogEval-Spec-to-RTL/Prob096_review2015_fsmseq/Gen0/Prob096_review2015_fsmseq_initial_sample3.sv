module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states
    typedef enum logic [2:0] {
        IDLE,
        GOT1,
        GOT11,
        GOT110,
        FOUND
    } state_t;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                start_shifting = 1'b0;
                next_state = data ? GOT1 : IDLE;
            end
            GOT1: begin
                start_shifting = 1'b0;
                next_state = data ? GOT11 : IDLE;
            end
            GOT11: begin
                start_shifting = 1'b0;
                next_state = data ? GOT11 : GOT110;
            end
            GOT110: begin
                start_shifting = 1'b0;
                next_state = data ? FOUND : IDLE;
            end
            FOUND: begin
                start_shifting = 1'b1;
                next_state = FOUND; // Stay here until reset
            end
            default: begin
                start_shifting = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

endmodule