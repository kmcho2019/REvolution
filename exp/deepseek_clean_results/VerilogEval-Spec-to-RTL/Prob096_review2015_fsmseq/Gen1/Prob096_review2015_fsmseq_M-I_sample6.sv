module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Define states with binary encoding
    typedef enum logic [1:0] {
        IDLE,     // 00
        GOT1,     // 01
        GOT11,    // 10
        FOUND     // 11
    } state_t;

    reg [1:0] current_state, next_state;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            // Output only changes when entering FOUND state
            if (next_state == FOUND)
                start_shifting <= 1'b1;
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

endmodule