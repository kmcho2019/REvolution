module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Current state and next state
reg [1:0] current_state, next_state;

// Output
reg out_reg;

// Combinational logic for next state
always @(*)
begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A; // Default state
    endcase
end

// Sequential logic for state update and output
always @(posedge clk)
begin
    if (reset)
    begin
        current_state <= A;
        out_reg <= 0;
    end
    else
    begin
        current_state <= next_state;
        case (current_state)
            A: out_reg <= 0;
            B: out_reg <= 0;
            C: out_reg <= 0;
            D: out_reg <= 1;
            default: out_reg <= 0; // Default output
        endcase
    end
end

// Assign output
assign out = out_reg;

endmodule