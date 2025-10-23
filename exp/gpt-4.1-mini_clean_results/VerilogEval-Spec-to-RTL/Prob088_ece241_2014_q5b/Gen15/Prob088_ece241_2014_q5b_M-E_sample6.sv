module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// State encoding: one-hot in 2-bit vector
// A = 2'b01, B = 2'b10
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// Next-state combinational logic
always @(*) begin
    case (state)
        A: next_state = (x == 1'b0) ? A : B;
        B: next_state = B; // stay in B regardless of x
        default: next_state = A; // safe default
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        z     <= 1'b0;
    end else begin
        state <= next_state;
        // Mealy output depends on current state and input x
        case (state)
            A: z <= x;    // z=1 if x=1, else 0
            B: z <= ~x;   // z=1 if x=0, else 0
            default: z <= 1'b0;
        endcase
    end
end

endmodule