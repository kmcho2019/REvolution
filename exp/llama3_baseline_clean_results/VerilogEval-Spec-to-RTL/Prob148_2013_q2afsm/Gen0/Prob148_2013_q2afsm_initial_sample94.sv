module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states
parameter A = 2'b00, B = 2'b01, C = 2'b10;

// Internal state register
reg [1:0] currentState, nextState;

// Continuous assignment for outputs based on the current state
assign g[0] = (currentState == B) ? 1'b1 : 1'b0;
assign g[1] = (currentState == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since state D isn't explicitly needed for g2

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case(currentState)
        A: begin
            if (r[0] == 1'b1) begin
                nextState = B;
            end else if (r[1] == 1'b1) begin
                nextState = C;
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
        default: begin
            nextState = A;
        end
    endcase
end

endmodule