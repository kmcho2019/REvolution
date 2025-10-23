module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state, 0 for OFF, 1 for ON
reg [0:0] next_state; // Next state

// Define the states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// State transitions
always @(*) begin
    case(state)
        OFF: begin
            if (j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF; // Default to OFF state
    endcase
end

// Output logic
assign out = (state == ON)? 1'b1 : 1'b0;

endmodule