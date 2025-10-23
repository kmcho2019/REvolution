module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

// Output z is a function of current state and input x
always @(*) begin
    case (state)
        A: z = ~x;
        B: z = x;
        default: z = 1'bx; // Don't care for other states
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        A: nextState = (x) ? B : A;
        B: nextState = B; // Self-loop for both x=0 and x=1
        default: nextState = A; // Don't care for other states
    endcase
end

// State update on positive edge of clock with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A; // Reset to state A
    end else begin
        state <= nextState;
    end
end

endmodule