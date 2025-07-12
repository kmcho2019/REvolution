module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

// Enum for states
typedef enum logic [0:0] {
    OFF,
    ON
} state_type;

// Current state
reg state_type current_state;

// Next state logic
always @(*) begin
    case (current_state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: next_state = OFF;
    endcase
end

// State register with asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= OFF; // Reset to OFF state
    end else begin
        current_state <= next_state; // Update state on clock edge
    end
end

// Output logic directly from state
assign out = (current_state == ON)? 1'b1 : 1'b0;

reg next_state;

endmodule