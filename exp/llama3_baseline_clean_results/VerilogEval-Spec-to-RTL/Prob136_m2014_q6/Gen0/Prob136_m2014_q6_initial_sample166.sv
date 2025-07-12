module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Current state
reg [2:0] currentState;
reg [2:0] nextState;

// Output z
assign z = (currentState == E) || (currentState == F);

// Next state logic
always @(*) begin
    case(currentState)
        A: begin
            if(w == 0) nextState = B;
            else nextState = A;
        end
        B: begin
            if(w == 0) nextState = C;
            else nextState = D;
        end
        C: begin
            if(w == 0) nextState = E;
            else nextState = D;
        end
        D: begin
            if(w == 0) nextState = F;
            else nextState = A;
        end
        E: begin
            if(w == 0) nextState = E;
            else nextState = D;
        end
        F: begin
            if(w == 0) nextState = C;
            else nextState = D;
        end
        default: nextState = A;
    endcase
end

// Update current state
always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule