module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // States
    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT11,
        FOUND
    } state_t;

    reg [1:0] current_state, next_state;
    reg [2:0] shift_reg;  // Stores last 3 bits

    // State transition and shift register update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_reg <= 3'b0;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            shift_reg <= {shift_reg[1:0], data};
            
            // Output logic
            if (current_state == GOT11 && shift_reg[1:0] == 2'b10 && data)
                start_shifting <= 1'b1;
            else if (current_state == FOUND)
                start_shifting <= 1'b1;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = (shift_reg[1:0] == 2'b10 && data) ? FOUND : 
                                (data ? GOT11 : IDLE);
            FOUND:  next_state = FOUND;
            default: next_state = IDLE;
        endcase
    end

endmodule