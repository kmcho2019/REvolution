module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state, next_state; // state[0]=A, state[1]=B

always @(*) begin
    next_state = 2'b00;
    case (1'b1)
        state[0]: // A
            next_state = x ? 2'b10 : 2'b01; // to B if x=1 else stay A
        state[1]: // B
            next_state = 2'b10;             // stay B
        default:
            next_state = 2'b01;             // default to A on invalid state
    endcase

    // Mealy output
    z = state[0] ? x : ~x;
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // reset to A
    else
        state <= next_state;
end

endmodule