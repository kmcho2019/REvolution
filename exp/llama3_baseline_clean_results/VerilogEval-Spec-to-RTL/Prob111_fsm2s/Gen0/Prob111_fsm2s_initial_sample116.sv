module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 1-bit signal to represent the current state
reg [0:0] next_state; // 1-bit signal to represent the next state

// Define the states
parameter OFF = 0;
parameter ON = 1;

// Determine the next state based on the current state and inputs
always @(*) begin
    case(state)
        OFF: begin
            if (j == 1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk) begin
    if (reset == 1) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Assign the output based on the current state
always @(*) begin
    case(state)
        OFF: out = 0;
        ON: out = 1;
        default: out = 0;
    endcase
end

endmodule