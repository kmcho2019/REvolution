module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

// Define states
parameter STATE_A = 1'b0;
parameter STATE_B = 1'b1;

// Combinational logic for next state
always @(*) begin
    case(state)
        STATE_A: begin
            if (in == 1'b1)
                next_state = STATE_A;
            else
                next_state = STATE_B;
        end
        STATE_B: begin
            if (in == 1'b1)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= STATE_B; // Asynchronous reset
    else
        state <= next_state;
end

// Output logic
assign out = state;

endmodule