module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

// Declare the current state and next state
reg [2:0] currentState;
reg [2:0] nextState;

// Assign the output based on the current state
always @(*)
begin
    case (currentState)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Calculate the next state
always @(*)
begin
    case (currentState)
        A: begin
            if (w == 1)
                nextState = A;
            else
                nextState = B;
        end
        B: begin
            if (w == 1)
                nextState = D;
            else
                nextState = C;
        end
        C: begin
            if (w == 1)
                nextState = D;
            else
                nextState = E;
        end
        D: begin
            if (w == 1)
                nextState = A;
            else
                nextState = F;
        end
        E: begin
            if (w == 1)
                nextState = D;
            else
                nextState = E;
        end
        F: begin
            if (w == 1)
                nextState = D;
            else
                nextState = C;
        end
        default: nextState = A;
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge reset)
begin
    if (reset == 1)
        currentState = A;
    else
        currentState = nextState;
end

endmodule