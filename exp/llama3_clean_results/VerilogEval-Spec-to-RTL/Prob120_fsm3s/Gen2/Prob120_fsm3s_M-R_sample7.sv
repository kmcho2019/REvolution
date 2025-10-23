module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Directly assign output based on current state
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'bx;
    endcase
end

// State transition logic
always_comb begin
    case ({current_state, in})
        {A, 1'b0}: next_state = A;
        {A, 1'b1}: next_state = B;
        {B, 1'b0}: next_state = C;
        {B, 1'b1}: next_state = B;
        {C, 1'b0}: next_state = A;
        {C, 1'b1}: next_state = D;
        {D, 1'b0}: next_state = C;
        {D, 1'b1}: next_state = B;
        default: next_state = A;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule