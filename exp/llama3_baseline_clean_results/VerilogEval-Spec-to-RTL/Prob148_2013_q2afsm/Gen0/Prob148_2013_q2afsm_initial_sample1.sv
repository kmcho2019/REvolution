module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the current and next state variables
reg [1:0] currentState;
reg [1:0] nextState;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// State table
always @(*) begin
    case (currentState)
        A: begin
            if (~r[0] && ~r[1] && ~r[2]) begin
                nextState <= A;
            end else if (r[0]) begin
                nextState <= B;
            end else if (r[1]) begin
                nextState <= C;
            end else if (r[2]) begin
                nextState <= A; // No transition to D as per the diagram
            end
        end
        B: begin
            if (r[0]) begin
                nextState <= B;
            end else begin
                nextState <= A;
            end
        end
        C: begin
            if (r[1]) begin
                nextState <= C;
            end else begin
                nextState <= A;
            end
        end
        default: begin
            nextState <= A;
        end
    endcase
end

// Output logic
assign g[0] = (currentState == B);
assign g[1] = (currentState == C);
assign g[2] = 1'b0; // No grant for device 2 as per the state diagram

endmodule