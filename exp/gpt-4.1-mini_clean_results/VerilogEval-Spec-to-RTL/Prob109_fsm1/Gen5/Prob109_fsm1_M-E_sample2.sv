module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot encoding for states
    // state_A = 2'b01, state_B = 2'b10
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state, next_state;

    // Combinational next state logic based on one-hot encoding
    always @(*) begin
        case (state)
            B: next_state = in ? B : A; // From B: 1->B, 0->A
            A: next_state = in ? A : B; // From A: 1->A, 0->B
            default: next_state = B;    // Default state
        endcase
    end

    // Sequential logic: state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends only on the state: out=1 if in B, else 0
    assign out = (state == B);

endmodule