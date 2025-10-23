module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // One-hot encoding: two bits for states
    // state_A = 2'b01, state_B = 2'b10
    localparam [1:0] STATE_A = 2'b01;
    localparam [1:0] STATE_B = 2'b10;

    reg [1:0] state, next_state;

    // Asynchronous active-high reset, state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: next_state = x ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B;
            default: next_state = STATE_A; // safe default/reset
        endcase
    end

    // Output logic (Mealy FSM): z = 1 when (A and x=1) or (B and x=0)
    always @(*) begin
        case (state)
            STATE_A: z = x ? 1'b1 : 1'b0;
            STATE_B: z = x ? 1'b0 : 1'b1;
            default: z = 1'b0;
        endcase
    end

endmodule