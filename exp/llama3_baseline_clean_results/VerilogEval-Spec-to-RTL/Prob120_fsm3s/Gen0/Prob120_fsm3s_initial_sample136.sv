module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} currentState, nextState;

// State transition logic
always_comb begin
    case(currentState)
        A: nextState = (in) ? B : A;
        B: nextState = (in) ? B : C;
        C: nextState = (in) ? D : A;
        D: nextState = (in) ? B : C;
        default: nextState = A;
    endcase
end

// Output logic
assign out = (currentState == D) ? 1'b1 : 1'b0;

// State register with synchronous reset
always_ff @(posedge clk) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule