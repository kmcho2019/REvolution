module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// One-hot state encoding as a 2-bit vector
localparam STATE_A = 2'b01;
localparam STATE_B = 2'b10;

reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_A;
        z <= 1'b0; // reset output to known state
    end else begin
        state <= next_state;
        // Output z is Mealy type, updated combinationally with state and x in this block
        case (state)
            STATE_A: z <= x;
            STATE_B: z <= ~x;
            default: z <= 1'b0;
        endcase
    end
end

// Combinational next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = x ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_B;
        default: next_state = STATE_A;
    endcase
end

endmodule