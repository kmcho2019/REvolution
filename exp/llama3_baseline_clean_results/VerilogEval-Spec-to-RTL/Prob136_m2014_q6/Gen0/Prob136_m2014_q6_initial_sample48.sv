module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states as parameters for clarity and ease of maintenance
parameter A = 5'b00001,
           B = 5'b00010,
           C = 5'b00100,
           D = 5'b01000,
           E = 5'b10000,
           F = 5'b00000; // Note: F uses 5'b00000 to distinguish it clearly

// Define the register to hold the current state
reg [4:0] currentState, nextState;

// Define the output z based on the current state
always @(*) begin
    case(currentState)
        A, B, C, D: z = 0;
        E, F:       z = 1;
        default:   z = 0; // Default to 0 for invalid states
    endcase
end

// Define the combinational logic for state transitions
always @(*) begin
    case(currentState)
        A: begin
            if (w == 1'b1) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            if (w == 1'b1) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        C: begin
            if (w == 1'b1) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        D: begin
            if (w == 1'b1) begin
                nextState = A;
            end else begin
                nextState = F;
            end
        end
        E: begin
            if (w == 1'b1) begin
                nextState = D;
            end else begin
                nextState = E;
            end
        end
        F: begin
            if (w == 1'b1) begin
                nextState = D;
            end else begin
                nextState = C;
            end
        end
        default: nextState = A; // Reset to state A for any other state
    endcase
end

// Define the sequential logic (flip-flop) to update the current state
always @(posedge clk) begin
    if (reset == 1'b1) begin
        currentState <= A; // Reset to state A on reset
    end else begin
        currentState <= nextState;
    end
end

endmodule