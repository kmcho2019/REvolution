module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
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
        default: next_state = OFF; // default to OFF state
    endcase
end

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule