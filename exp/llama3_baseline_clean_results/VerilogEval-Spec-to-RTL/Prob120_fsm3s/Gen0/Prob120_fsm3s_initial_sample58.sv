module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Encoding of states: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic based on current state
always @(*) begin
    case (current_state)
        2'b00: out = 1'b0; // State A
        2'b01: out = 1'b0; // State B
        2'b10: out = 1'b0; // State C
        2'b11: out = 1'b1; // State D
        default: out = 1'b0;
    endcase
end

// Next state logic based on current state and input
always @(*) begin
    case (current_state)
        2'b00: next_state = in? 2'b01 : 2'b00; // State A
        2'b01: next_state = in? 2'b01 : 2'b10; // State B
        2'b10: next_state = in? 2'b11 : 2'b00; // State C
        2'b11: next_state = in? 2'b01 : 2'b10; // State D
        default: next_state = 2'b00;
    endcase
end

// Sequential logic for state register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

endmodule