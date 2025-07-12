module TopModule(
    input           clk,
    input           reset,
    input           in,
    output          out
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Current state register
reg [1:0] state;
reg [1:0] nextState;

// State transition logic
always @(*) begin
    case(state)
        A: begin
            if (!in) nextState = A;
            else      nextState = B;
        end
        B: begin
            if (!in) nextState = C;
            else      nextState = B;
        end
        C: begin
            if (!in) nextState = A;
            else      nextState = D;
        end
        D: begin
            if (!in) nextState = C;
            else      nextState = B;
        end
        default: nextState = A; // default state
    endcase
end

// Output logic (Moore machine, output depends on state)
always @(*) begin
    case(state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'b0; // default output
    endcase
end

// State update (synchronous active high reset)
always @(posedge clk or posedge reset) begin
    if (reset) state <= A; // Reset to state A
    else state <= nextState;
end

endmodule