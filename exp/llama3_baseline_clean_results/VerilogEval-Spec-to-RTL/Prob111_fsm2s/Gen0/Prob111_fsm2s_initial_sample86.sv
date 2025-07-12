module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
parameter OFF_STATE = 0;
parameter ON_STATE = 1;

// Define the current state and next state
reg state;
reg next_state;

// Assign the output based on the current state
assign out = (state == ON_STATE) ? 1 : 0;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= OFF_STATE;
    end else begin
        case(state)
            OFF_STATE: begin
                if (j) begin
                    state <= ON_STATE;
                end else begin
                    state <= OFF_STATE;
                end
            end
            ON_STATE: begin
                if (k) begin
                    state <= OFF_STATE;
                end else begin
                    state <= ON_STATE;
                end
            end
        endcase
    end
end

endmodule