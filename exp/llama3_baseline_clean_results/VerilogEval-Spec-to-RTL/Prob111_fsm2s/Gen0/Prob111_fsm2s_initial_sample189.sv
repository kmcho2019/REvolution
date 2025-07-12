module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
parameter OFF = 0, ON = 1;
reg [0:0] state, next_state;

// Moore state machine
always @(*) begin
    case(state)
        OFF: begin
            if(j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if(k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Output logic
always @(*) begin
    case(state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if(reset) state <= OFF;
    else state <= next_state;
end

endmodule