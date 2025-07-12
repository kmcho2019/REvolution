module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b100;

// Declare the current and next states
reg [2:0] currentState;
reg [2:0] nextState;

// Sequential logic to update the current state
always @(posedge clk) begin
    if (!resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Combinational logic to determine the next state
always @* begin
    case (currentState)
        A: begin
            if (r[0]) begin
                nextState = B;
            end else if (r[1]) begin
                nextState = C;
            end else if (r[2]) begin
                nextState = A;
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
            nextState = A;
        end
        default: begin
            nextState = A;
        end
    endcase
end

// Continuous assignment to determine the outputs g
assign g[0] = (currentState == B) ? 1'b1 : 1'b0;
assign g[1] = (currentState == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0;

endmodule