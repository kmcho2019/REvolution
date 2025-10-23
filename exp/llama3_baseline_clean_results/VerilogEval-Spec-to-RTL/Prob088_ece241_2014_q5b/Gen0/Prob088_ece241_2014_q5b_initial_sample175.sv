module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

// One-hot encoding: A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

// Output z logic based on current state and input x
assign z = (state == A && x == 1'b1) || (state == B && x == 1'b0);

// Next state logic
always @(*) begin
    case(state)
        A: nextState = x ? B : A;
        B: nextState = B; // Regardless of x, stay in B
        default: nextState = A; // Default state
    endcase
end

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

endmodule