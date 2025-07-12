module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states
parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

// State register
reg [2:0] state, nextState;

// State table
always @(*) begin
    case(state)
        A: nextState = w ? B : A;
        B: nextState = w ? C : D;
        C: nextState = w ? E : D;
        D: nextState = w ? F : A;
        E: nextState = w ? E : D;
        F: nextState = w ? C : D;
        default: nextState = A;
    endcase
end

// State flip-flops
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Output z
assign z = (state == E) || (state == F);

endmodule