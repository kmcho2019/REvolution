module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

typedef enum logic [1:0] {
    S00 = 2'b00,  // Previous=0, Current=0
    S01 = 2'b01,  // Previous=0, Current=1 (rising edge)
    S10 = 2'b10,  // Previous=1, Current=0 (falling edge)
    S11 = 2'b11   // Previous=1, Current=1
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S00;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S00: next_state = a ? S01 : S00;
        S01: next_state = a ? S11 : S10;
        S10: next_state = a ? S01 : S00;
        S11: next_state = a ? S11 : S10;
        default: next_state = S00;
    endcase
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        rise <= (current_state == S00 && next_state == S01);
        down <= (current_state == S11 && next_state == S10);
    end
end

endmodule