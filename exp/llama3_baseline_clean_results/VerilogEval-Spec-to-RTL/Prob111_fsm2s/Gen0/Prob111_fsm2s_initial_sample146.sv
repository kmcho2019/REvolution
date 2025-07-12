module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

reg current_state, next_state;

// Output logic
always @(current_state)
begin
    case (current_state)
        OFF: out = 1'b0;
        ON: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// State transition logic
always @(posedge clk)
begin
    if (reset) begin
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
            default: current_state <= OFF;
        endcase
    end
end

endmodule