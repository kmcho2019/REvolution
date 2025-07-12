module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State table
always @(*) begin
    case (currentState)
        A: nextState = w ? B : A;
        B: nextState = w ? C : D;
        C: nextState = w ? E : D;
        D: nextState = w ? F : A;
        E: nextState = w ? E : D;
        F: nextState = w ? C : D;
        default: nextState = A; // Default to state A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Output z
always @(*) begin
    case (currentState)
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule