module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Declare the current and next state variables
reg [1:0] currentState;
reg [1:0] nextState;

// Use continuous assignment for output g
assign g = (currentState == B) ? 3'b100 : ((currentState == C) ? 3'b010 : 3'b000);

// Next state logic
always @(currentState, r) begin
    case(currentState)
        A: begin
            if (r[0]) begin
                nextState = B;
            end else if (r[1]) begin
                nextState = C;
            end else if (r[2]) begin
                nextState = D;  // Though not described, follow state code definition for completeness
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (r[0]) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        C: begin
            if (r[1]) begin
                nextState = C;
            end else begin
                nextState = A;
            end
        end
        D: begin
            // Though D is not described in the state diagram, assign it back to A for simplicity
            nextState = A;
        end
        default: begin
            nextState = A;  // Handle any invalid state, default to A
        end
    endcase
end

// Current state flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule