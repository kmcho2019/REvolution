module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] state, next_state;

// State Flip-Flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State Table
always @(*) begin
    case(state)
        A: begin
            if (!r[0] && !r[1] && !r[2]) next_state = A;
            else if (r[0]) next_state = B;
            else if (r[1]) next_state = C;
            else if (r[2]) next_state = D;
        end
        B: begin
            if (r[0]) next_state = B;
            else next_state = A;
        end
        C: begin
            if (r[1]) next_state = C;
            else next_state = A;
        end
        D: begin
            next_state = A; // Since D does not have a condition in the original FSM description, we will default it back to A.
        end
        default: next_state = A;
    endcase
end

// Output Logic
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since D does not set any g output in the original description, we leave g[2] as 0.

endmodule