module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// State encoding
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Current state and next state variables
reg current_state;
reg next_state;

// Output logic
always @(current_state) begin
    case (current_state)
        OFF: out = 1'b0;
        ON:  out = 1'b1;
        default: out = 1'bx; // Should never reach here
    endcase
end

// State machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
            default: current_state <= OFF; // Should never reach here
        endcase
    end
end

endmodule