module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// State register
reg [2:0] state;
reg [2:0] nextState;

// Output z is assigned based on the current state
assign z = (state == E || state == F);

always @(*) begin
    case (state)
        A: nextState = (w) ? B : A;
        B: nextState = (w) ? C : D;
        C: nextState = (w) ? E : D;
        D: nextState = (w) ? F : A;
        E: nextState = (w) ? E : D;
        F: nextState = (w) ? C : D;
        default: nextState = A; // Default to state A
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

endmodule