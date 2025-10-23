module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot state encoding
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Next state logic using conditional operator
always @(*) begin
    next_state = (state == A) ? ((x == 1'b1) ? B : A) :
                 B;
end

// Output logic in separate always block (Mealy: depends on state and input)
always @(*) begin
    case (state)
        A: z = (x == 1'b1) ? 1'b1 : 1'b0;
        B: z = (x == 1'b0) ? 1'b1 : 1'b0;
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