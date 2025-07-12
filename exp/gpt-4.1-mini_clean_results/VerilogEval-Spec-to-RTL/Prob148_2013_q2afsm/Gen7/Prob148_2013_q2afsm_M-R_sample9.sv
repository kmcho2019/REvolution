module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

localparam A=2'd0, B=2'd1, C=2'd2, D=2'd3;

reg [1:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case(state)
        A: begin
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        B: next_state = (r[0]) ? B : A;
        C: next_state = (r[1]) ? C : A;
        D: next_state = (r[2]) ? D : A;
        default: next_state = A;
    endcase
end

// Function to decode grants from state
function [2:0] state_to_g;
    input [1:0] st;
    begin
        case (st)
            B: state_to_g = 3'b001;
            C: state_to_g = 3'b010;
            D: state_to_g = 3'b100;
            default: state_to_g = 3'b000;
        endcase
    end
endfunction

// Assign output grant signals
assign g = state_to_g(state);

endmodule