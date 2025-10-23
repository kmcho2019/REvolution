module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011
} state, next_state;

// State transition logic
always_comb begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = D;
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
        D: begin
            // Assuming D is a don't care for this problem
            next_state = A;
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always_ff @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Continuous assignment for outputs
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since g[2] is not defined in the state diagram

endmodule