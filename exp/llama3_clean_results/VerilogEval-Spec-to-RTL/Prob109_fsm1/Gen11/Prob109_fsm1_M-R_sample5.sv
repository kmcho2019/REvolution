module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as an enumeration
enum logic [0:0] {STATE_A, STATE_B} state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= STATE_B; // Reset to state B
    end else begin
        state <= next_state; // Update state on the next clock cycle
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        STATE_A: begin
            if (~in) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_B: begin
            if (~in) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_B;
            end
        end
        default: next_state = STATE_B; // Default to STATE_B
    endcase
end

// Out is directly derived from the state in this implementation
assign out = (state == STATE_B) ? 1'b1 : 1'b0;

endmodule