module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Define states
typedef enum logic [1:0] {
    S4 = 2'b00,
    S5 = 2'b01,
    S6 = 2'b10,
    S0 = 2'b11
} state_t;

state_t current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        S4: next_state = a ? S4 : S5;
        S5: next_state = a ? S4 : S6;
        S6: next_state = a ? S4 : S0;
        S0: next_state = a ? S4 : S5;
        default: next_state = S4;
    endcase
end

// State register
always @(posedge clk) begin
    current_state <= next_state;
end

// Output logic
always @(*) begin
    case (current_state)
        S4: q = 3'd4;
        S5: q = 3'd5;
        S6: q = 3'd6;
        S0: q = 3'd0;
        default: q = 3'd4;
    endcase
end

endmodule