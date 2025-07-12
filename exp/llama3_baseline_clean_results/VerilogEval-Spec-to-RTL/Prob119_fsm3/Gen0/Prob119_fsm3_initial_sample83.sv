module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Variable to keep track of the current state
reg [1:0] currentState;
reg [1:0] nextState;

// Output variable
reg outReg;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Next state logic
always @(*) begin
    case (currentState)
        A: begin
            if (!in) begin
                nextState <= A;
            end else begin
                nextState <= B;
            end
        end
        B: begin
            if (!in) begin
                nextState <= C;
            end else begin
                nextState <= B;
            end
        end
        C: begin
            if (!in) begin
                nextState <= A;
            end else begin
                nextState <= D;
            end
        end
        D: begin
            if (!in) begin
                nextState <= C;
            end else begin
                nextState <= B;
            end
        end
        default: begin
            nextState <= A;
        end
    endcase
end

// Output logic
always @(*) begin
    case (currentState)
        A: outReg <= 0;
        B: outReg <= 0;
        C: outReg <= 0;
        D: outReg <= 1;
        default: outReg <= 0;
    endcase
end

assign out = outReg;

endmodule