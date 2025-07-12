module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // State register to hold the current state
reg [0:0] next_state; // Next state register for state transition

// Define states
parameter OFF = 0;
parameter ON  = 1;

// Output logic (Moore state machine outputs are a function of the state only)
always @(state)
begin
    case(state)
        OFF: out <= 0;
        ON:  out <= 1;
        default: out <= 0; // default state
    endcase
end

// State transition logic
always @(*)
begin
    case(state)
        OFF:
        begin
            if(j == 1) next_state <= ON;
            else next_state <= OFF;
        end
        ON:
        begin
            if(k == 1) next_state <= OFF;
            else next_state <= ON;
        end
        default: next_state <= OFF; // default next state
    endcase
end

// State register with synchronous reset
always @(posedge clk)
begin
    if(reset == 1) state <= OFF;
    else state <= next_state;
end

endmodule