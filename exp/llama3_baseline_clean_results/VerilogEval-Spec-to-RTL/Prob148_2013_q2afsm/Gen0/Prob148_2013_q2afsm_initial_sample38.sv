module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the current state and next state
reg [1:0] currentState;
reg [1:0] nextState;

// Define the output g
assign g[0] = (currentState == B);
assign g[1] = (currentState == C);
assign g[2] = (currentState == D);

// State table
always @(*) begin
    case (currentState)
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
            // This state is not actually reached based on the given state diagram
            // But we include it for completeness
            nextState = A;
        end
        default: begin
            nextState = A;
        end
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule