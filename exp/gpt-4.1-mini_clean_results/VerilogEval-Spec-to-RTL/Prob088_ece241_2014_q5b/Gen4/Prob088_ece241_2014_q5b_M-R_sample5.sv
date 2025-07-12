module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);
    // One-hot state encoding
    localparam [1:0] STATE_A = 2'b01;
    localparam [1:0] STATE_B = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
    assign next_state = (state == STATE_A) ? (x ? STATE_B : STATE_A) : STATE_B;

    // Output logic (Mealy)
    // z=1 when (state==A and x=1) or (state==B and x=0)
    assign z = (state[0] & x) | (state[1] & ~x);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= next_state;
    end

endmodule