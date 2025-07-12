module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Decoding the states
wire [3:0] A = 4'b0001;
wire [3:0] B = 4'b0010;
wire [3:0] C = 4'b0100;
wire [3:0] D = 4'b1000;

// Combinational logic for state transitions and output
always @(*)
begin
    case (state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
            out = 0;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 0;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
            out = 0;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
            out = 1;
        end
        default: begin
            next_state = 4'bxxxx; // This should never happen in a one-hot encoded FSM
            out = 1'bx; // Default output to avoid latch inference
        end
    endcase
end

endmodule