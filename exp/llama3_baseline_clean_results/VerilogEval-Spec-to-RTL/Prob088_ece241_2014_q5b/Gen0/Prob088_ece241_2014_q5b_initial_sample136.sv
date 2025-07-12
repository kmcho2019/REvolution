module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;  // one-hot encoded state
reg [1:0] nextState;  // one-hot encoded next state

// one-hot encoded state definitions
parameter A = 2'b01;
parameter B = 2'b10;

// combinational logic for output z
always @(*)
begin
    case (state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0;
    endcase
end

// sequential logic for state transitions
always @(posedge clk or posedge areset)
begin
    if (areset)
    begin
        state <= A;
    end
    else
    begin
        case (state)
            A: if (x) state <= B; else state <= A;
            B: state <= B;  // stay in state B regardless of x
            default: state <= A;
        endcase
    end
end

endmodule