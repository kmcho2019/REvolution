module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Internal one-hot encoding for the states
reg [5:0] currentState;
reg [5:0] nextState;

// One-hot encoding for each state
localparam A = 6'b000001;
localparam B = 6'b000010;
localparam C = 6'b000100;
localparam D = 6'b001000;
localparam E = 6'b010000;
localparam F = 6'b100000;

// Determine the next state
always @(*) begin
    case(currentState)
        A: begin
            if(w == 1'b1)
                nextState = A;
            else
                nextState = B;
        end
        B: begin
            if(w == 1'b1)
                nextState = D;
            else
                nextState = C;
        end
        C: begin
            if(w == 1'b1)
                nextState = D;
            else
                nextState = E;
        end
        D: begin
            if(w == 1'b1)
                nextState = A;
            else
                nextState = F;
        end
        E: begin
            if(w == 1'b1)
                nextState = D;
            else
                nextState = E;
        end
        F: begin
            if(w == 1'b1)
                nextState = D;
            else
                nextState = C;
        end
        default: nextState = A; // Default to state A
    endcase
end

// Update the current state
always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= A; // Reset to state A
        z <= 1'b0; // Initialize output z
    end else begin
        currentState <= nextState;
        // Determine output z based on the current state
        case(currentState)
            E, F: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule