module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// One-hot encoding for states A and B
reg [1:0] state;
reg [1:0] next_state;

// Define the state encoding
parameter A = 2'b01;
parameter B = 2'b10;

// Output z is a combinational function of state and input x
always @(state, x) begin
    case(state)
        A: z = ~x;
        B: z = x;
        default: z = 1'bx;
    endcase
end

// Asynchronous reset, synchronous state update
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state
always @(state, x) begin
    case(state)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A;
    endcase
end

endmodule