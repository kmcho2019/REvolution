module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // States
    typedef enum logic [1:0] {
        WAIT,
        CHECK,
        FOUND
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= WAIT;
            shift_reg <= 3'b0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            
            // Only update shift register when actively checking
            if (state != FOUND) begin
                shift_reg <= {shift_reg[1:0], data};
            end
            
            // Output is high only in FOUND state
            start_shifting <= (next_state == FOUND);
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WAIT: 
                next_state = (data) ? CHECK : WAIT;
            CHECK: 
                next_state = (shift_reg == 3'b110 && data) ? FOUND : CHECK;
            FOUND: 
                next_state = FOUND;
            default: 
                next_state = WAIT;
        endcase
    end

endmodule