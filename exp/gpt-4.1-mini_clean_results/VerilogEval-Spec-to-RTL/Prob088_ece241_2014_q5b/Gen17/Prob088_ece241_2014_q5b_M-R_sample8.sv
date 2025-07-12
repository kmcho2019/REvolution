module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // State encoding (one-hot)
    localparam [1:0] STATE_A = 2'b01,
                     STATE_B = 2'b10;

    reg [1:0] state, next_state;

    // Next-state logic (combinational)
    // From A: if x=0 stay in A, if x=1 go to B
    // From B: stay in B regardless of x
    always @(*) begin
        case (state)
            STATE_A: next_state = (x) ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B;
            default: next_state = STATE_A; // safety fallback
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Output logic (Mealy): z depends on current state and input x
    // A: z = x
    // B: z = ~x
    assign z = (state == STATE_A) ? x : ~x;

endmodule