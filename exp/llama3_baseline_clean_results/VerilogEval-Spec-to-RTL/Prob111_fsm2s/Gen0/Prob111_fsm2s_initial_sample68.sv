module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// State variable
reg state;

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to OFF state
        state <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                end
            end
            default: begin
                state <= OFF; // Default to OFF state
            end
        endcase
    end
end

// Output logic
always @(state) begin
    case (state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
        default: out <= 1'b0; // Default to 0
    endcase
end

endmodule