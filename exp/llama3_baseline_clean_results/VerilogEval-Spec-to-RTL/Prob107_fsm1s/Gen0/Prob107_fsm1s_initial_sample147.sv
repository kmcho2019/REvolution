module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states
parameter B = 1'b0;
parameter A = 1'b1;

reg current_state;
reg next_state;

// Combinational logic for next state and output
always @(*)
begin
    case(current_state)
        B:
            begin
                if (~in)
                    next_state = A;
                else
                    next_state = B;
            end
        A:
            begin
                if (~in)
                    next_state = B;
                else
                    next_state = A;
            end
        default:
            next_state = B; // Default state
    endcase

    case(current_state)
        B:
            out = 1'b1;
        A:
            out = 1'b0;
        default:
            out = 1'b1; // Default output for B
    endcase
end

// Sequential logic for state update
always @(posedge clk)
begin
    if (reset)
        current_state <= B;
    else
        current_state <= next_state;
end

initial
begin
    current_state = B;
end

endmodule