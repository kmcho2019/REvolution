module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define states as enumerations
typedef enum logic[1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current state register
state_t current_state, next_state;

// Determine output based on current state
assign out = (current_state == D) ? 1'b1 : 1'b0;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (current_state)
        A: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        C: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
        end
        default: next_state = A; // Should never happen
    endcase
end

endmodule