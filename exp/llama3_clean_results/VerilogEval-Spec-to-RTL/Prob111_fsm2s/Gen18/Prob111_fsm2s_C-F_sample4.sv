module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output logic out
);

// Define the states as an enumeration
typedef enum logic [0:0] {
    OFF,
    ON
} state_type;

// State variable
state_type state, next_state;

// State transition and output logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case (state)
            OFF: begin
                state <= (j) ? ON : OFF;
                out <= (j) ? 1'b1 : 1'b0;
            end
            ON: begin
                state <= (~k) ? ON : OFF;
                out <= (~k) ? 1'b1 : 1'b0;
            end
        endcase
    end
end

endmodule