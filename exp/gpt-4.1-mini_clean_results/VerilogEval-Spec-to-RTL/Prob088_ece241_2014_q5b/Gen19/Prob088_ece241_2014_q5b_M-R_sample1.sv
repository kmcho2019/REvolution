module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case (state)
        A: next_state = (x) ? B : A;
        B: next_state = B;
        default: next_state = A; // safety default
    endcase
end

// Output logic (Mealy)
always @(*) begin
    case (state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0;
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

endmodule