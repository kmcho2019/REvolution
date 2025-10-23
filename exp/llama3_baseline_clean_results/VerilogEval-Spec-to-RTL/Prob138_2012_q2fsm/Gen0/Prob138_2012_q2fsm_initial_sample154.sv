module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// State codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State register
reg [2:0] state, nextState;

// Combinational logic for next state
always @(*) begin
    case(state)
        A: nextState = (w) ? B : A;
        B: nextState = (w) ? C : D;
        C: nextState = (w) ? E : D;
        D: nextState = (w) ? F : A;
        E: nextState = (w) ? E : D;
        F: nextState = (w) ? C : D;
        default: nextState = A; // Default to A for any other state
    endcase
end

// Sequential logic for state flip-flops
always @(posedge clk) begin
    if(reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= nextState;
    end
end

// Output logic
always @(*) begin
    case(state)
        A, B, C, D: z = 0;
        E, F: z = 1;
        default: z = 0; // Default output to 0 for any other state
    endcase
end

endmodule