module TopModule (
    input clk,
    input areset,
    input in,
    output logic out
);

// Define states
enum logic [0:0] {STATE_B, STATE_A} state, next_state;

// Output logic
always_comb begin
    case(state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'b0; // Default to STATE_A's output if state is unknown
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case(state)
        STATE_B: begin
            if (in == 1'b1) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_A: begin
            if (in == 1'b1) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end
        default: next_state = STATE_B; // Default to STATE_B if state is unknown
    endcase
end

endmodule