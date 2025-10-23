module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Current and next state
reg [1:0] current_state, next_state;

// Continuous assignment for outputs
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since there's no grant for r2 in the state machine description

// Next state logic
always @(*)
begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                // For completeness, though the state diagram does not show A transitioning to D explicitly,
                // we can infer that if only r2 is high, it transitions to a state where only g2 could be high.
                // However, the description does not specify any grant for r2, so we leave this as is.
                next_state = A; // Since D does not have an explicit grant condition
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule