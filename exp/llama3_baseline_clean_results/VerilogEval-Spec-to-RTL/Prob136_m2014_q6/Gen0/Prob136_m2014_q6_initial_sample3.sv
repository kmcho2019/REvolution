module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define state encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define current and next states
reg [2:0] currentState, nextState;

// Determine the output z based on the current state
always @(*) begin
    case (currentState)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Determine the next state based on the current state and input w
always @(*) begin
    case (currentState)
        A: nextState = (w == 1'b0) ? B : A;
        B: nextState = (w == 1'b0) ? C : D;
        C: nextState = (w == 1'b0) ? E : D;
        D: nextState = (w == 1'b0) ? F : A;
        E: nextState = (w == 1'b0) ? E : D;
        F: nextState = (w == 1'b0) ? C : D;
        default: nextState = A;
    endcase
end

// Update the current state on the rising edge of clk
always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule