module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// One-hot encoded states
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

reg [1:0] state, next_state;

// State decoding signals
wire in_A = (state == STATE_A);
wire in_B = (state == STATE_B);

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = x ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_B;
        default: next_state = STATE_A; // safe default
    endcase
end

// Output logic (Mealy)
assign z = (in_A & x) | (in_B & ~x);

// Sequential state register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= STATE_A;
    else
        state <= next_state;
end

endmodule