module TopModule (
    input x,
    input y,
    input clk,    // Added clock for sequential implementation
    input rst,    // Added reset
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        S00 = 2'b00,
        S01 = 2'b01,
        S10 = 2'b10,
        S11 = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S00;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case ({x, y})
            2'b00: next_state = S00;
            2'b01: next_state = S01;
            2'b10: next_state = S10;
            2'b11: next_state = S11;
            default: next_state = S00;
        endcase
    end

    // Output logic - matches the XNOR behavior through state machine
    always @(*) begin
        case (current_state)
            S00: z = 1'b1;
            S01: z = 1'b0;
            S10: z = 1'b0;
            S11: z = 1'b1;
            default: z = 1'b1;
        endcase
    end

endmodule