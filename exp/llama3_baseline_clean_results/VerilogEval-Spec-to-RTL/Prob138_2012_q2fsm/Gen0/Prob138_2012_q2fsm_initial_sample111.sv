module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
parameter A = 0;
parameter B = 1;
parameter C = 2;
parameter D = 3;
parameter E = 4;
parameter F = 5;

// Define the current state and next state
reg [2:0] currentState;
reg [2:0] nextState;

// State table
always @(*)
begin
    case(currentState)
        A: begin
            if (w) begin
                nextState = B;
            end else begin
                nextState = A;
            end
        end
        B: begin
            if (w) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        C: begin
            if (w) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        D: begin
            if (w) begin
                nextState = F;
            end else begin
                nextState = A;
            end
        end
        E: begin
            if (w) begin
                nextState = E;
            end else begin
                nextState = D;
            end
        end
        F: begin
            if (w) begin
                nextState = C;
            end else begin
                nextState = D;
            end
        end
        default: begin
            nextState = A;
        end
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Describe the output z
assign z = (currentState == E) || (currentState == F);

endmodule