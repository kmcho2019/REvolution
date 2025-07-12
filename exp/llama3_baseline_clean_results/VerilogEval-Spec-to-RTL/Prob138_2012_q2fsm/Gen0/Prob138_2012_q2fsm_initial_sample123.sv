module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define state codes
parameter A = 4'b0001,
           B = 4'b0010,
           C = 4'b0100,
           D = 4'b1000,
           E = 4'b0000,
           F = 4'b0110;

reg [3:0] currentState, nextState;

// State Flip-Flops
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Next State Logic
always @(*) begin
    case (currentState)
        A:    nextState = w ? B : A;
        B:    nextState = w ? C : D;
        C:    nextState = w ? E : D;
        D:    nextState = w ? F : A;
        E:    nextState = (w && 1'b1) ? E : D;
        F:    nextState = (w && 1'b1) ? C : D;
        default: nextState = A; // Should never reach here, but for simulation
    endcase
end

// Output Logic
always @(*) begin
    case (currentState)
        A:    z = 0;
        B:    z = 0;
        C:    z = 0;
        D:    z = 0;
        E:    z = 1;
        F:    z = 1;
        default: z = 0; // Should never reach here, but for simulation
    endcase
end

endmodule