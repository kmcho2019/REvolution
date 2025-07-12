module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// One-hot state encoding
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

reg [3:0] state, next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Next state logic with one-hot encoding using combinational logic
always @(*) begin
    case (1'b1)
        state[A]: next_state = in ? B : A;
        state[B]: next_state = in ? B : C;
        state[C]: next_state = in ? D : A;
        state[D]: next_state = in ? B : C;
        default:  next_state = A;
    endcase
end

// Output logic: out=1 only in state D, else 0
always @(*) begin
    out = state[D];
end

endmodule