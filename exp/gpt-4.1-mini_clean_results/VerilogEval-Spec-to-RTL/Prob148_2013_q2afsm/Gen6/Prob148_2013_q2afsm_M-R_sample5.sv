module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// One-hot encoding for states
localparam [3:0]
    A = 4'b0001,
    B = 4'b0010,
    C = 4'b0100,
    D = 4'b1000;

reg [3:0] state, next_state;

// Combinational next state logic function
function [3:0] get_next_state;
    input [3:0] curr_state;
    input [2:0] req;
    begin
        case (curr_state)
            A: begin
                // Priority: r[0] > r[1] > r[2]
                if (req[0]) get_next_state = B;
                else if (req[1]) get_next_state = C;
                else if (req[2]) get_next_state = D;
                else get_next_state = A;
            end
            B: get_next_state = req[0] ? B : A;
            C: get_next_state = req[1] ? C : A;
            D: get_next_state = req[2] ? D : A;
            default: get_next_state = A;
        endcase
    end
endfunction

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    next_state = get_next_state(state, r);
end

// Outputs from one-hot state encoding: grant bit corresponds to the state B, C, D
assign g = {state[3], state[2], state[1]}; // g[2]=state D, g[1]=state C, g[0]=state B

endmodule