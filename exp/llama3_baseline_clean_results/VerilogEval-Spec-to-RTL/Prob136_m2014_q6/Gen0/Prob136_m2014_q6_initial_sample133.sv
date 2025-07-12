module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] currentState; // 3-bit register to store the current state
reg [2:0] nextState;   // 3-bit register to store the next state

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Determine the next state based on the current state and input 'w'
always @(*) begin
    case (currentState)
        A: begin
            if (w == 1'b0) nextState = B;
            else nextState = A;
        end
        B: begin
            if (w == 1'b0) nextState = C;
            else nextState = D;
        end
        C: begin
            if (w == 1'b0) nextState = E;
            else nextState = D;
        end
        D: begin
            if (w == 1'b0) nextState = F;
            else nextState = A;
        end
        E: begin
            if (w == 1'b0) nextState = E;
            else nextState = D;
        end
        F: begin
            if (w == 1'b0) nextState = C;
            else nextState = D;
        end
        default: nextState = A; // Default state is A
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        currentState <= A; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

// Determine the output 'z' based on the current state
always @(*) begin
    case (currentState)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0; // Default output is 0
    endcase
end

endmodule