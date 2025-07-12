module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot encoded state vector: 2'b01 = A, 2'b10 = B
reg [1:0] state, next_state;

localparam A = 2'b01;
localparam B = 2'b10;

// Next state logic
always @(*) begin
    case (state)
        A: next_state = x ? B : A;
        B: next_state = B;
        default: next_state = A;
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Mealy output logic
always @(*) begin
    case (state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0;
    endcase
end

endmodule