module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;

// Define the states
parameter A = 2'b10;
parameter B = 2'b01;

always @(*) begin
    // Determine the next state based on the current state and input x
    case (state)
        A: if (!x) nextState = A;
           else     nextState = B;
        B: nextState = B;
        default:    nextState = A;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset, set the state to A
        state <= A;
    end else begin
        // Update the state at the positive edge of the clock
        state <= nextState;
    end
end

// Determine the output z based on the current state and input x
always @(*) begin
    case (state)
        A: z = x;
        B: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule