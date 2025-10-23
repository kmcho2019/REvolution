module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the current state and next state
reg [1:0] currentState;
reg [1:0] nextState;

// Continuous assignment for outputs
assign g[0] = (currentState == B);
assign g[1] = (currentState == C);
assign g[2] = 0; // Since there's no state that sets g[2] to 1

// State table
always @(*) begin
    case(currentState)
        A: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else if (r[1] == 1'b1) begin
                nextState = C;
            end else if (r[2] == 1'b1) begin
                nextState = D;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                nextState = C;
            end else begin
                nextState = A;
            end
        end
        D: begin
            // There's no next state defined for state D in the given state diagram
            // Assuming it should stay in state D if r[2] is still 1
            if (r[2] == 1'b1) begin
                nextState = D;
            end else begin
                nextState = A;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule