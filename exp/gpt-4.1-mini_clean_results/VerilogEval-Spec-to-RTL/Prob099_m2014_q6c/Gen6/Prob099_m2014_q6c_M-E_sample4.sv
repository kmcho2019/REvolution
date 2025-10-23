module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // Next-state bit corresponding to B (y[1])
    output       Y3   // Next-state bit corresponding to D (y[3])
);

// Function to compute all next-state bits (for reference, though only Y1 and Y3 are output)
function [5:0] next_state;
    input [5:0] curr;
    input       w_in;
    begin
        // next A (y[0]) is set from D state with w=1: D(0,1)->A only w=1 transition from D
        // But since only Y1 and Y3 outputs are required, we focus on these
        // next B (y[1]) = A & ~w
        next_state[1] = curr[0] & ~w_in;

        // next D (y[3]) = w & (B | C | D | E | F)
        next_state[3] = w_in & (curr[1] | curr[2] | curr[3] | curr[4] | curr[5]);

        // Other bits are zero since not requested
        next_state[0] = 1'b0;
        next_state[2] = 1'b0;
        next_state[4] = 1'b0;
        next_state[5] = 1'b0;
    end
endfunction

wire [5:0] ns = next_state(y, w);

assign Y1 = ns[1];
assign Y3 = ns[3];

endmodule