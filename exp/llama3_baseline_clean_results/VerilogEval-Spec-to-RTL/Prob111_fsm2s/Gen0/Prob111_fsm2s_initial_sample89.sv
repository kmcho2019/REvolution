module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// Enum for states
enum {OFF, ON} state, next_state;

// Always block for sequential logic
always @ (posedge clk) begin
    if (reset) begin
        // Active-high synchronous reset to state OFF
        state <= OFF;
    end else begin
        // State transition logic
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
        endcase
    end
end

// Combinational logic for output
always @ (*) begin
    case (state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
    endcase
end

endmodule