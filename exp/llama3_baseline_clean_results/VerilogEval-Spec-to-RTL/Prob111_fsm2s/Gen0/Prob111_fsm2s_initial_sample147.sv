module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state; // Variable to hold the current state
reg next_state; // Variable to determine the next state

// Directly assign output based on the state
assign out = state;

always @ (posedge clk) begin
    if (reset) begin // Active-high reset
        state <= OFF; // Reset to OFF state
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end else begin
                    state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end else begin
                    state <= ON;
                end
            end
            default: state <= OFF; // Default to OFF if state is unknown
        endcase
    end
end

endmodule