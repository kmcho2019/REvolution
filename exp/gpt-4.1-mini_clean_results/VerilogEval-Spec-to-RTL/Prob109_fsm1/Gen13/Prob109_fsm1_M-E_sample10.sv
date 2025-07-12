module TopModule (
    input        clk,
    input        areset,
    input        in,
    output       out
);

    // State encoding using two bits (one-hot style)
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic based on current state and input
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;  // B(1) --0--> A, --1--> B
            A: next_state = in ? A : B;  // A(0) --0--> B, --1--> A
            default: next_state = B;     // safe default
        endcase
    end

    // State register with asynchronous reset to state B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends only on state: 1 when in B, else 0
    assign out = (state == B);

endmodule