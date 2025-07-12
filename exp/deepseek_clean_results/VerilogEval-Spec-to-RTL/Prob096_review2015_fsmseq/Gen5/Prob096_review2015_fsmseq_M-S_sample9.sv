module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states with binary encoding
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        GOT1   = 2'b01,
        GOT11  = 2'b10,
        FOUND  = 2'b11
    } state_t;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE:   next_state = data ? GOT1 : IDLE;
            GOT1:   next_state = data ? GOT11 : IDLE;
            GOT11:  next_state = data ? GOT11 : (data ? FOUND : IDLE);
            FOUND:  next_state = FOUND;
        endcase
    end

    // Output logic
    always @(*) begin
        start_shifting = (current_state == FOUND);
    end

endmodule