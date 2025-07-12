module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states
parameter STATE_A = 0;
parameter STATE_B = 1;

// Define the current state and next state
reg [0:0] state;
reg [0:0] next_state;

// Define the output based on the current state
always @(state) begin
    case(state)
        STATE_A: out = 0;
        STATE_B: out = 1;
        default: out = 1;
    endcase
end

// Determine the next state based on the current state and input
always @(*) begin
    case(state)
        STATE_A: begin
            case(in)
                0: next_state = STATE_B;
                1: next_state = STATE_A;
            endcase
        end
        STATE_B: begin
            case(in)
                0: next_state = STATE_A;
                1: next_state = STATE_B;
            endcase
        end
        default: next_state = STATE_B;
    endcase
end

// Update the current state on each rising edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_B;
    end else begin
        state <= next_state;
    end
end

endmodule