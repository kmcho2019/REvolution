module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Enumerate states and assign unique binary codes
// For simplicity, we use binary representation from 0 to 5 for states A to F
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

// State register
reg [2:0] currentState, nextState;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize state to A upon reset
        currentState <= A;
    end else begin
        // Update current state with next state at every positive clock edge
        currentState <= nextState;
    end
end

// Combinational logic to determine next state based on current state and input 'w'
always @(*) begin
    case(currentState)
        A: begin
            if (w == 1'b0) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (w == 1'b0) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        C: begin
            if (w == 1'b0) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        D: begin
            if (w == 1'b0) begin
                nextState = F;
            end else begin
                nextState = A;
            end
        end
        E: begin
            if (w == 1'b0) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        F: begin
            if (w == 1'b0) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        default: begin
            // Default state, should not occur under normal operation
            nextState = A;
        end
    endcase
end

// Determine output 'z' based on current state
// For this example, we output 'z' as '1' for states E and F, and '0' otherwise
always @(*) begin
    case(currentState)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule