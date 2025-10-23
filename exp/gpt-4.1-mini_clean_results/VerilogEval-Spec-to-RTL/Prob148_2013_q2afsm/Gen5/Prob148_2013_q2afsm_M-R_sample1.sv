module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

typedef enum logic [1:0] {
    A = 2'd0,
    B = 2'd1,
    C = 2'd2,
    D = 2'd3
} state_t;

state_t state, next_state;

// Next state function: computes next state based on current state and inputs
function automatic state_t f_next_state(state_t curr, input [2:0] req);
    begin
        case (curr)
            A: begin
                if (req[0])
                    f_next_state = B;
                else if (req[1])
                    f_next_state = C;
                else if (req[2])
                    f_next_state = D;
                else
                    f_next_state = A;
            end
            B: f_next_state = req[0] ? B : A;
            C: f_next_state = req[1] ? C : A;
            D: f_next_state = req[2] ? D : A;
            default: f_next_state = A;
        endcase
    end
endfunction

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= f_next_state(state, r);
end

// Outputs directly assigned based on current state
assign g = (state == B) ? 3'b001 :
           (state == C) ? 3'b010 :
           (state == D) ? 3'b100 : 3'b000;

endmodule