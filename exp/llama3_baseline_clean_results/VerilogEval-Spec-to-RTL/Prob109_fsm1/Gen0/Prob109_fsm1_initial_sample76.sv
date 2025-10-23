module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Enum for states
enum logic [0:0] {B, A} state, next_state;

// Assign output based on state
assign out = (state == A) ? 0 : 1;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= B;
    end else begin
        case (state)
            B: begin
                if (in) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            A: begin
                if (in) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            default: begin
                state <= B; // Should never reach here
            end
        endcase
    end
end

endmodule