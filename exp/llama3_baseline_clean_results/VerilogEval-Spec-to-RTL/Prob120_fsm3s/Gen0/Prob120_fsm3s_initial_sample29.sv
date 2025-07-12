module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter STATE_WIDTH = 2;
parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

// Reg to hold the current state
reg [STATE_WIDTH - 1:0] current_state;

// Determine the next state based on the current state and input
reg [STATE_WIDTH - 1:0] next_state;
always @(*) begin
    case (current_state)
        STATE_A: next_state = in? STATE_B : STATE_A;
        STATE_B: next_state = in? STATE_B : STATE_C;
        STATE_C: next_state = in? STATE_D : STATE_A;
        STATE_D: next_state = in? STATE_B : STATE_C;
        default: next_state = STATE_A;
    endcase
end

// Determine the output based on the current state
always @(*) begin
    case (current_state)
        STATE_A, STATE_B, STATE_C: out = 1'b0;
        STATE_D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

endmodule